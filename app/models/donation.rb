require 'set'

class Donation < ActiveRecord::Base
  attr_accessor :col_custom

  belongs_to :committee
  belongs_to :batch
  has_many :tweets

  def self.import
    batch = Batch.create
    Committee.set_fec_ids
    set_donat_lookup
    f = File.open("lib/data/02032015itcont.txt", "r:bom|utf-8") 
    donations = SmarterCSV.process(f, {
      key_mapping: {
        :cmte_id => "rptcom_fec_id",
        :TRANSACTION_DT.downcase => "date",
        :NAME.downcase => "full_name",
        :TRANSACTION_AMT.downcase => "amount",
        :SUB_ID.downcase => "fec_record_num"
      },
      :chunk_size => 10000,
      col_sep: "|",
      convert_values_to_numeric: false}) do |chunk|
      chunk.each do |don|
        don[:date] = date_convert(don[:date])
        don[:amount] = don[:amount].to_i
        don[:batch_id] = batch.id
        don[:first_name] = first_name(don[:full_name])
        don[:last_name] = last_name(don[:full_name])
      end
      import_chunk(chunk)
      end
    f.close
  end

  def self.first_name(full_name)
    if full_name
      full_name.split(",").last
    else
      nil
    end
  end

  def self.last_name(full_name)
    if full_name
      full_name.split(",").first
    else
      nil
    end
  end

  def self.date_convert(date_string)
    if date_string
      Date.strptime(date_string, '%m%d%Y')
    else
      nil
    end
  end

  def self.set_donat_lookup
    @@donat_lookup = Set.new
    Donation.all.each do |donation|
      @@donat_lookup << donation.fec_record_num
    end
  end


  

  def self.donat_lookup
    @@donat_lookup
  end
   
  def self.import_chunk(donations_dat)
    donations_dat.each do |donation_dat|
      fec_record_num = donation_dat[:fec_record_num]
      fec_id = donation_dat[:rptcom_fec_id]
        if Committee.com_fec_ids[fec_id] && !donat_lookup.include?(fec_record_num)
          donation = Donation.new(donation_dat)
          committee = Committee.com_fec_ids[fec_id]
          donation.committee = committee
          donation.save
        end
    end
  end

  def tweetify
    handle = "@#{self.committee.candidate.twitter_handle}"
    "Let's congratulate #{handle} on the $#{self.amount} of influence he sold to #{self.first_name} #{self.last_name} of #{self.employer}!"
  end

  def self.last_batch
    Batch.last.donations
  end

  def self.dup_trans(donations=nil)
    if ! donations
      donations = Donation.all
    end
    results = {}
    donations.each do |donation|
      if results[donation.tran_id]
        results[donation.tran_id] << donation
      else
        results[donation.tran_id] = [donation]
      end
    end
    dup_results = []
    results.each do |tran_id, donation_array|
      if donation_array.length > 1
        length = donation_array.length
        donation_array.each do |donation|
          donation.col_custom = {count_tran_id: length}
          dup_results << donation
        end
      end
    end
    dup_results.flatten
  end

  def self.to_csv(data, name = nil)
    Csv.new.write_file(data, name)
  end
  # def self.test
  #   results = [
  #     { Alabama: [
  #       House: [
  #         {"Calvin Johnson" =>}
  #       ]
        
  #       ]
  #     },
  #     { Alsaska: [
  #       {House: [
  #         ]}
  #       ]
  #       }
  #     } 
  #   ]
  # end
 
end

# Donation.select('tran_id, id, count(tran_id)').group('tran_id').having('count(tran_id) > 1')
# Donation.select('*, count(tran_id)').group('tran_id').having('count(tran_id) > 1')