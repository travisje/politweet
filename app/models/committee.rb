class Committee < ActiveRecord::Base
  belongs_to :candidate
  has_many :donations

  def self.fec_id_glossary
    committees = Committee.all
    glossary = {}
    committees.each do |committee|
      glossary[committee.fec_id] = committee.id
    end
    glossary
  end

end
