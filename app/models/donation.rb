require 'set'

class Donation < ActiveRecord::Base
  attr_accessor :col_custom

  belongs_to :committee
  delegate :candidate, :to => :committee, :allow_nil => true
  belongs_to :batch
  has_many :tweets

  @@for_bulk_insert = []

  #TODO move to an importer class
  def self.import_csv_and_create(validate=true)
    batch = Batch.create
    set_fec_ids
    committee_fec_id_glossary = Committee.fec_id_glossary
    committees_for_batch_inserting = []

    # CHANGE
    # Committee.set_fec_ids
    # set_donat_lookup

    f = File.open("lib/data/itcont.txt", "r:bom|utf-8") 
    donations = SmarterCSV.process(f, {
      key_mapping: {
        :cmte_id => "rptcom_fec_id",
        :TRANSACTION_DT.downcase => "date",
        :NAME.downcase => "full_name",
        :TRANSACTION_AMT.downcase => "amount",
        :SUB_ID.downcase => "fec_record_num"
      },
      :chunk_size => 50000,
      col_sep: "|",
      convert_values_to_numeric: false}) do |chunk|
        chunk.each do |donation|
          donation[:date] = date_convert(donation[:date])
          donation[:amount] = donation[:amount].to_i
          donation[:batch_id] = batch.id
          donation[:first_name] = first_name(donation[:full_name])
          donation[:last_name] = last_name(donation[:full_name])
        end
        import_chunk(chunk, committee_fec_id_glossary)
        #TODO clean data. Check for multiple dup fec_ids
        Donation.import(for_bulk_insert, validate: validate)
        @@for_bulk_insert = []
      end
    f.close
  end

  def strip_out_unknown_committees

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

  def self.set_fec_ids
    @@donat_lookup = Donation.pluck(:rptcom_fec_id)
  end

  def self.fec_ids
    @@donat_lookup
  end

  def self.for_bulk_insert
    @@for_bulk_insert  
  end

   
  def self.import_chunk(donations_params, committee_fec_id_glossary)
    donations_params.each do |donation_params|
      
      committee_fec_id = donation_params[:rptcom_fec_id]
      fec_record_num = donation_params[:fec_record_num]

      # Ignore donations that we don't have existing committee id's for or that we already have a donation record for
      # TODO add updater for existing donations the have been changed by FEC
      # TODO add multiple insert statement capability for speed
      next if !committee_fec_id_glossary[committee_fec_id] || fec_ids.include?(fec_record_num)
      donation_params[:committee_id] = committee_fec_id_glossary[committee_fec_id]
      @@for_bulk_insert << Donation.new(donation_params)
    end
  end


  def self.last_batch
    Batch.last.donations
  end

  #OLD but keeping for reference 
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