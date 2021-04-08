require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
    it {should have_many(:pet_applications)}
    it { should have_many(:applications).through(:pet_applications)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create!(name: 'Max Fund', city: 'Denver', foster_program: true, rank:4)
    @pet_1 = @shelter_1.pets.create!(name: 'Francine', breed: 'dog', age: 1, adoptable: true)
    @pet_2 = @shelter_1.pets.create!(name: 'Joey', breed: 'dog', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create!(name: 'Mr. Dog', breed: 'cat', age: 10, adoptable: false)

  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("Joey")).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end
  end
end
