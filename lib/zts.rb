require 'net/http'
require 'json'

class ZTS
  def self.prepend_zeroes(zip)
  	zip[0] += '0'*(5 - zip.length)
  end
  
  def self.clean_zip(zip)
  	zip = zip.to_s.gsub(' ','').gsub(/(?<=\d{5})-.+/,'')
  	if zip.length < 5
  		prepend_zeroes(zip)
  	end
  	zip
  end

  def self.get_response(zip)
  	uri = URI("http://api.zippopotam.us/us/#{zip}")
  	res = Net::HTTP.get(uri)
  	JSON.parse(res)
  end

  # Takes a zip as an integer or string and returns the state or nil
  # if none could be found
  def self.zip_to_state(zip)
  	zip = zip.to_s
  	json = get_response( clean_zip( zip ) )
  	unless json['places'].nil?
  		return json['places'][0]['state abbreviation']
    else 
  		return nil
  	end
  end
end
