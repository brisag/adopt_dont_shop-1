require 'rails_helper'

RSpec.describe 'As a visitor' do
  describe 'When I visit the new application page' do
    before :each do
      @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
      @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

      @applicant_1 = Application.create!(name: 'Mike', address: '123 10th ave', city: 'Denver', state: 'CO', zip_code: 80205, description: "I need cuddly pets", status: 'Pending')
      @applicant_2 = Application.create!(name: 'John', address: '321 15th ave', city: 'Denver', state: 'CO', zip_code: 80205, description: "I need cuddly pets", status: 'Approved')
      @applicant_3 = Application.create!(name: 'Charles', address: '678 street ave', city: 'Denver', state: 'CO', zip_code: 80205, description: "I need cuddly pets", status: 'Pending')


      PetApplication.create(application: @applicant_1, pet: @pet_1)
      PetApplication.create(application: @applicant_1, pet: @pet_2)
      PetApplication.create(application: @applicant_2, pet: @pet_3)
      PetApplication.create(application: @applicant_3, pet: @pet_3)

      visit '/admin/shelters'
    end

    it 'displays all Shelters in the system listed in reverse alphabetical order by name' do

      expect(@shelter_2.name).to appear_before(@shelter_3.name)
      expect(@shelter_3.name).to appear_before(@shelter_1.name)
    end

    it "shows section for names of Shelter's with Pending Applications" do
      within("#pending-apps") do
        # save_and_open_page
        expect(page).to have_content("Shelters with Pending Applications")
        expect(page).to have_content(@shelter_1.name)
        expect(page).to have_content(@shelter_3.name)
      end
    end
  end
end
