require "bundler/setup"
require 'webmock/rspec'
require 'vcr'
require 'faraday'

VCR.configure do |c|
  c.cassette_library_dir = "spec/vcr/"
  c.hook_into :faraday, :webmock
end

RSpec.describe VCR do
  it "generates one_character" do
    VCR.use_cassette("one_character") do
      response = Faraday.get('https://gateway.marvel.com/v1/public/characters/1011334?ts=1526908517&apikey=f6f9e528cf58c18c9a282a88c5e7ac08&hash=fd5ae1fd02011df0bc1cd5aa27a2466d')
    end
  end

  it "generates multiple_character_10" do
    VCR.use_cassette("multiple_character_10") do
      response = Faraday.get('https://gateway.marvel.com/v1/public/characters?ts=1526908519&apikey=f6f9e528cf58c18c9a282a88c5e7ac08&hash=36f855b8536bb71de82e611906fd0ad0&limit=10&offset=0')
    end
  end

  it "generates spider_man" do
    VCR.use_cassette("spider_man") do
      response = Faraday.get('https://gateway.marvel.com/v1/public/characters?ts=1526908522&apikey=f6f9e528cf58c18c9a282a88c5e7ac08&hash=8fdb5742cfa39ecda5912d177b12de37&name=Spider-Man&limit=10&offset=0')
    end
  end

  it "generates multiple_character_20" do
    VCR.use_cassette("multiple_character_20") do
      response = Faraday.get('https://gateway.marvel.com/v1/public/characters?ts=1526908526&apikey=f6f9e528cf58c18c9a282a88c5e7ac08&hash=38cb86752ad070a88b6f0cdeb7d7f20a&limit=20&offset=0')
    end
  end
end
