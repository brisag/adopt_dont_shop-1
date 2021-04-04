require 'rails_helper'

describe Application, type: :model do
  before :each do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

    @applicant_1 = Application.create!(name: 'Mike', address: '123 10th ave', city: 'Denver', state: 'CO', zip_code: 80205, description: "I need cuddly pets", status: 'Pending')
    @applicant_2 = Application.create!(name: 'John', address: '321 15th ave', city: 'Denver', state: 'CO', zip_code: 80205, description: "I need cuddly pets", status: 'Approved')

    PetApplication.create(application: @applicant_1, pet: @pet_1)
    PetApplication.create(application: @applicant_1, pet: @pet_2)
    PetApplication.create(application: @applicant_2, pet: @pet_3)
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
end
