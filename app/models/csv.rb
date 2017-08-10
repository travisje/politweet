class Csv

  attr_accessor :headers

  def write_file(data, name=nil)
    set_headers(data)
    CSV.open("output/#{file_name(name)}", "wb") do |csv|
      csv << headers
      data.each do |record|
        record_hash = all_attributes(record)
        row = []
        headers.each do |column|
          row << record_hash[column]
        end
        binding.pry
        csv << row
      end
    end
  end

  def file_name(name=nil)
    time_string = Time.now.to_s.gsub(" ","")
    if name
      name = name.to_s
      time_string << "_"
      time_string << name
    end
    time_string << ".csv"
  end

  def all_attributes(record)
    result = record.attributes
    if record.col_custom
      result = result.merge(record.col_custom)
    end
    result # a hash
  end

  def set_headers(results)
    self.headers = []
    sample = results[0]
    all_attributes(sample).each do |attribute, value|
      self.headers << attribute
    end
  end

end