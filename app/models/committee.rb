class Committee < ActiveRecord::Base
  belongs_to :candidate
  has_many :donations

  @@com_fec_ids = {}

  def self.set_fec_ids
    committees = Committee.all
    committees.each do |committee|
      @@com_fec_ids[committee.fec_id] = committee
    end
  end

  def self.com_fec_ids
    @@com_fec_ids
  end

end
