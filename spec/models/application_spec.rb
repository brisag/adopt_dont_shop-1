require 'rails_helper'

describe Application, type: :model do
  before :each do
    @shelter1 = Shelter.create!(name: 'Max Fund', city: 'Denver', foster_program: true, rank:4)
    @shelter2 = Shelter.create!(name: 'Dumb Friends', city: 'Boulder', foster_program: true, rank:5)
    @shelter3 = Shelter.create!(name: 'Animal Rescue', city: 'Fort Collins', foster_program: true, rank:4)

    @pet1 = @shelter1.pets.create!(name: 'Francine', breed: 'dog', age: 1, adoptable: true)
    @pet2 = @shelter2.pets.create!(name: 'Joey', breed: 'dog', age: 3, adoptable: true)
    @pet3 = @shelter1.pets.create!(name: 'Mr. Dog', breed: 'cat', age: 10, adoptable: true)

    @applicant1 = Application.create!(name: 'Brisa', address: '123 10th ave', city: 'Denver', state: 'CO', zip_code: 80205, description: "i need cuddly pets")
    @applicant2 = Application.create!(name: 'John', address: '321 Blake st', city: 'Denver', state: 'CO', zip_code: 80204, description: "i need cute pets")
    @applicant3 = Application.create!(name: 'Max', address: '1000 Broadway st', city: 'Eerie', state: 'CO', zip_code: 80041, description: "i need funny pets")
    @applicant4 = Application.create!(name: 'Xotchil', address: '1610 wewatta wy', city: 'Berthoud', state: 'CO', zip_code: 80491, description: "i need smart pets")

    PetApplication.create!(pet: @pet1, application: @applicant1)
    PetApplication.create!(pet: @pet1, application: @applicant2)
    PetApplication.create!(pet: @pet2, application: @applicant1)
    PetApplication.create!(pet: @pet2, application: @applicant2)
  end

  describe 'relationships' do
    it {should have_many(:pet_applications)}
    it {should have_many(:pets).through(:pet_applications)}

  end
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip_code}
  end

  describe 'instance methods' do
    it '@street_address' do
      street_address = "#{@applicant1.address} #{@applicant1.city}, #{@applicant1.state}. #{@applicant1.zip_code}"

      expect(@applicant1.street_address).to eq(street_address)
    end
  end
end
