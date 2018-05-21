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
    private_class_method :construct_params, :construct_optional_params
  end
end
