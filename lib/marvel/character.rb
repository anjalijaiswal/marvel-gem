require 'faraday'
require 'json'
require 'digest'

API_URL = "https://gateway.marvel.com/v1/public/characters"

module Marvel
  class Character
    attr_reader :id, :name, :description, :resourceURI, :thumbnail, :comics, :events, :series, :modified, :stories, :urls

    def initialize(attributes)
      @id = attributes["id"]
      @name = attributes["name"]
      @description = attributes["description"]
      @resourceURI = attributes["resourceURI"]
      @thumbnail = attributes["thumbnail"]
      @comics = attributes["comics"]
      @events = attributes["events"]
      @series = attributes["series"]
      @modified = attributes["modified"]
      @stories = attributes["stories"]
      @urls = attributes["urls"]
    end

    def self.find(id)
      return "Incorrect id format" unless (id.is_a?Integer) && ((id.to_s =~ /^-/) != 0)
      begin
        request_params = construct_params
        url = "#{API_URL}/#{id}?#{request_params}"
        response = Faraday.get(url)
        attributes = JSON.parse(response.body)['data']['results'].first
        new(attributes)
      rescue
        "Some error occured. Please try again"
      end
    end

    def self.find_all(options = {})
      return "Incorrect params format" unless params_valid?(options)
      begin
        optional_params = construct_optional_params(options)
        request_params = construct_params
        response = Faraday.get("#{API_URL}?#{request_params}#{optional_params}")
        JSON.parse(response.body)['data']['results'].map do |datum|
          new(datum)
        end
      rescue
        "Some error occured. Please try again"
      end
    end

    def self.construct_params
      ts = Time.now.to_i.to_s
      md5 = Digest::MD5.new
      hash = md5.update(ts + Marvel.configuration.privateKey + Marvel.configuration.publicKey).hexdigest
      "ts=#{ts}&apikey=#{Marvel.configuration.publicKey}&hash=#{hash}"
    end

    def self.construct_optional_params(options)
      options.merge!(limit: 10, offset: 0) unless options.key?(:limit)
      options.map{|attribute, value| "&#{attribute}=#{value}"}.join
    end

    def self.params_valid?(options)
      options.each do |k,v|
        if k == :limit || k == :offset
          return false unless (v.is_a?Integer) && ((v.to_s =~ /^-/) != 0)
        end
      end
    end

    private_class_method :construct_params, :construct_optional_params, :params_valid?
  end
end
