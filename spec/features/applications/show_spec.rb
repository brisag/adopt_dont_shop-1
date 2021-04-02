require 'rails_helper'

RSpec.describe 'As a visitor' do
  describe 'When i visit the application show page' do
    before :each do
      @applicant1 = Application.create!(name: 'Brisa', address: '123 10th ave', city: 'Denver', state: 'CO', zip_code: 80205, description: "I need cuddly pets")
      @shelter1 = Shelter.create!(name: 'Max Fund', city: 'Denver', foster_program: true, rank:4)
      @pet3 = @shelter1.pets.create!(name: 'Mr. Dog', breed: 'cat', age: 10, adoptable: true)
      PetApplication.create!(pet: @pet3, application: @applicant1)

      visit "/applications/#{@applicant1.id}"
    end

    it "shows the applicant and attributes, description, and app status" do
      save_and_open_page
      within("#application-#{@applicant1.id}") do
        expect(page).to have_content(@applicant1.name)
        expect(page).to have_content(@applicant1.address)
        expect(page).to have_content(@applicant1.description)
        expect(page).to have_link("Mr. Dog")
        expect(page).to have_content('In Progress')
      end
    end
  end
end
