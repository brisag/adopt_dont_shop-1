require 'rails_helper'

RSpec.describe 'As a visitor' do
  describe 'When I visit the admin shelter index page' do
    before :each do
      @shelter_1 = Shelter.create!(name: 'Max Fund', city: 'Denver', foster_program: true, rank:4)
      @shelter_2 = Shelter.create!(name: 'Dumb Friends', city: 'Boulder', foster_program: true, rank:5)
      @shelter_3 = Shelter.create!(name: 'Animal Rescue', city: 'Fort Collins', foster_program: true, rank:4)

      @pet1 = @shelter_1.pets.create!(name: 'Francine', breed: 'dog', age: 1, adoptable: true)
      @pet2 = @shelter_2.pets.create!(name: 'Joey', breed: 'dog', age: 3, adoptable: true)
      @pet3 = @shelter_1.pets.create!(name: 'Mr. Dog', breed: 'cat', age: 10, adoptable: true)
      @pet4 = @shelter_1.pets.create!(name: 'Arthur', breed: 'dog', age: 1, adoptable: true)
      @pet5 = @shelter_3.pets.create!(name: 'Toy', breed: 'dog', age: 3, adoptable: true)
      @pet6 = @shelter_3.pets.create!(name: 'Mrs. Cat', breed: 'cat', age: 10, adoptable: true)

      @applicant1 = Application.create!(name: 'Brisa', address: '123 10th ave', city: 'Denver', state: 'CO', zip_code: 80205, description: "i need cuddly pets", status: "Pending")
      @applicant2 = Application.create!(name: 'John', address: '321 Blake st', city: 'Denver', state: 'CO', zip_code: 80204, description: "i need cute pets", status: "Approved")
      @applicant3 = Application.create!(name: 'Max', address: '1000 Broadway st', city: 'Eerie', state: 'CO', zip_code: 80041, description: "i need funny pets", status: "Pending")
      @applicant4 = Application.create!(name: 'Xotchil', address: '1610 wewatta wy', city: 'Berthoud', state: 'CO', zip_code: 80491, description: "i need smart pets", status: "Approved")

      PetApplication.create!(pet: @pet1, application: @applicant1)
      PetApplication.create!(pet: @pet1, application: @applicant2)
      PetApplication.create!(pet: @pet2, application: @applicant1)
      PetApplication.create!(pet: @pet2, application: @applicant2)

      visit '/admin/shelters'
    end

    it 'displays all Shelters in the system listed in reverse alphabetical order by name' do

      expect(@shelter_1.name).to appear_before(@shelter_2.name)
      expect(@shelter_2.name).to appear_before(@shelter_3.name)
    end

    it "shows section for names of Shelter's with Pending Applications" do
      within("#pending-apps") do
        save_and_open_page
        expect(page).to have_content("Shelters with Pending Applications")
        expect(page).to have_content(@shelter_1.name)
        expect(page).to have_content(@shelter_2.name)
      end
    end

    it "And the shelters with pending applications are in alphabetical order" do
      visit '/admin/shelters'

      within("#pending-apps") do
        expect(@shelter_2.name).to appear_before(@shelter_1.name)
      end
    end

    it "I see ever shelter name link is that takes you to admin shelter show page" do
      within("#shelter-#{@shelter_1.id}") do
        click_link("#{@shelter_1.name}")
      end
      expect(current_path).to eq("/admin/shelters/#{@shelter_1.id}")
    end

    it 'I see a section for statistics' do
      visit "/admin/shelters/#{@shelter_1.id}"

      within(".statistics") do
        expect(page).to have_content('Statistics')
      end
    end
  end
end
