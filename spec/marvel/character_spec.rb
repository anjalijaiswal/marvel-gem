RSpec.describe Marvel::Character do
  it "gives back a single marvel character" do
    VCR.use_cassette('one_character', :record => :new_episodes) do
      character = Marvel::Character.find(1011334)
      expect(character.id).to eq 1011334
      expect(character.name).to eq "3-D Man"
      expect(character.resourceURI).to eq "http://gateway.marvel.com/v1/public/characters/1011334"
    end
  end

  it "returns error if id is negative" do
    error = Marvel::Character.find(-1011334)
    expect(error).to eq "Incorrect id format"
    expect(Marvel::Character.find("dsla")).to eq "Incorrect id format"
  end

  it "gives back array of multiple marvel character" do
    VCR.use_cassette('multiple_character_10', :record => :new_episodes) do
      characters = Marvel::Character.find_all
      expect(characters.size).to eq 10
      expect(characters.first.id).to eq 1011334
      expect(characters.first.name).to eq "3-D Man"
      expect(characters.first.resourceURI).to eq "http://gateway.marvel.com/v1/public/characters/1011334"
    end
  end

  it "gives back array of marvel characters name like Spider-Man" do
    VCR.use_cassette('spider_man', :record => :new_episodes) do
      characters = Marvel::Character.find_all({name: 'Spider-Man'})
      expect(characters.first.id).to eq 1009610
      expect(characters.first.name).to eq "Spider-Man"
      expect(characters.first.resourceURI).to eq "http://gateway.marvel.com/v1/public/characters/1009610"
    end
  end

  it "gives back array of 20 marvel characters" do
    VCR.use_cassette('multiple_character_20', :record => :new_episodes) do
      characters = Marvel::Character.find_all({limit: 20, offset: 0})
      expect(characters.size).to eq 20
    end
  end
end
