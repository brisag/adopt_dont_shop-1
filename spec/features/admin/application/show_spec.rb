require 'rails_helper'

RSpec.describe 'As a visitor' do
  describe 'When I visit the admin application show page' do
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

      visit "/admin/applications/#{@applicant_1.id}"
    end

    it "next to every pet, it has button to approve the application for that specific pet" do

      within("#admin-applicant-#{@applicant_1.id}") do
        expect(page).to have_button('Approve')
      end
    end

    it "I click that button, am taken to the admin application show page and see an indicator its approved" do
      within("#admin-applicant-#{@applicant_1.id}") do
        within("#pet-#{@pet_1.id}") do
          click_button('Approve')
        end
        expect(current_path).to eq("/admin/applications/#{@applicant_1.id}")
      end
    end

    it "next to every pet, it has button to REJECT the application for that specific pet" do

      within("#admin-applicant-#{@applicant_1.id}") do
        expect(page).to have_button('Reject')
      end
    end

    it "I click that button, am taken to the admin application show page and see and indicator its been rejected" do
      within("#admin-applicant-#{@applicant_1.id}") do
        within("#pet-#{@pet_1.id}") do
          click_button('Reject')
        end
        expect(current_path).to eq("/admin/applications/#{@applicant_1.id}")
      end
    end

    it "if i go to any other show page, even if i accept/reject same pet for anothe app, i can still see accept/reject buttons" do
    end
  end
end
