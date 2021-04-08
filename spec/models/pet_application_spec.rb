require "rails_helper"

describe PetApplication, type: :model do
  describe "relationships" do
    it { should belong_to :pet }
    it { should belong_to :application }
  end

  describe "validations" do
    it { should validate_presence_of :application_id }
    it { should validate_presence_of :pet_id }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: true, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    @applicant1 = Application.create!(name: 'Brisa', address: '123 10th ave', city: 'Denver', state: 'CO', zip_code: 80205, description: "i need cuddly pets", status: "Pending")
    @applicant2 = Application.create!(name: 'John', address: '321 Blake st', city: 'Denver', state: 'CO', zip_code: 80204, description: "i need cute pets", status: "Approved")
    @applicant3 = Application.create!(name: 'Max', address: '1000 Broadway st', city: 'Eerie', state: 'CO', zip_code: 80041, description: "i need funny pets", status: "Pending")
    @applicant4 = Application.create!(name: 'Xotchil', address: '1610 wewatta wy', city: 'Berthoud', state: 'CO', zip_code: 80491, description: "i need smart pets", status: "Approved")

    @pet_app= PetApplication.create!(pet: @pet_1, application: @applicant1)
  end

  describe 'instance methods' do
    it 'can be approved' do
      @pet_app.approve
      expect(@pet_app.status).to eq("Approve")
    end

    it 'can be rejected' do
      @pet_app.reject
      expect(@pet_app.status).to eq("Reject")
    end
  end
end
