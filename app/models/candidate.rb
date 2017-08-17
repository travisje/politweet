require 'open-uri'

class Candidate < ActiveRecord::Base
  
  acts_as_taggable
  
  has_many :committees
  has_many :donations, through: :committees

  #TODO Move to an importer class
  
  def self.request(request_url)
    base_url = "https://api.open.fec.gov/v1/"
    api_request = base_url+request_url
    api_response = open(api_request).read
    JSON.parse(api_response)["results"]
  end

  def self.make_candidates(tags=nil)
    f = File.open("lib/data/114th_members.csv", "r:bom|utf-8") 
    candidates = SmarterCSV.process(f, {key_mapping: {:feccandid => "fec_id", :office => "district", :cid=> "crp_id", :crpname=> "last_name"}})
    f.close
    candidates.each do |candidate_raw|
      names = candidate_raw[:last_name].split(", ")
      last_name = names[0]
      first_name = names[1]
      state = candidate_raw[:district][0..1]
      district = candidate_raw[:district][2..3]
      candidate = Candidate.new(fec_id: candidate_raw[:fec_id], state: state, district: district, last_name: last_name, first_name: first_name, crp_id: candidate_raw[:crp_id])
      candidate.district = district
      candidate.state = state
      if tags
        candidate.tag_list.add(tags, parse: true)
      end
      candidate.save
    end
  end
  
  def self.add_principal_camp
    Candidate.all.each do |candidate|
      url = "https://api.open.fec.gov/v1/candidate/#{candidate.fec_id}/committees/?sort_nulls_large=true&sort=name&designation=P&per_page=20&api_key=#{ENV['FEC_api_key']}"
      api_response = open(url).read
      parsed = JSON.parse(api_response)

      parsed["results"].each do |com_data|
        candidate.committees.build(fec_id: com_data["committee_id"], name: com_data["name"], category: com_data["designation_full"], election_cycles: com_data["cycles"].join(", "))
        if com_data["committee_type_full"] == "House" || com_data[ "committee_type_full"] == "Senate"
          candidate.chamber = com_data["committee_type_full"]
        end
      end
      candidate.save
    end
  end

  def self.add_twitter(candidates) 

    candidates.each do |candidate|
      url = "http://www.opensecrets.org/api/?method=getLegislators&id=#{candidate.crp_id}&apikey=#{ENV['CRP_key']}&output=json"
      api_response = open(url).read
      parsed = JSON.parse(api_response)
      candidate.twitter_handle = parsed["response"]["legislator"]["@attributes"]["twitter_id"]
      candidate.party = parsed["response"]["legislator"]["@attributes"]["party"]
      candidate.save
    end

  end

  def self.by_name(name)
    Candidate.find_by(last_name: name)
  end

end
