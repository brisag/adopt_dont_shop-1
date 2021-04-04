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
      within("#application-#{@applicant1.id}") do
        expect(page).to have_content(@applicant1.name)
        expect(page).to have_content(@applicant1.address)
        # expect(page).to have_content(@applicant1.description)
        expect(page).to have_content('In Progress')
      end
    end

    it "I see a section and search that says add pet to this application" do
      expect(page).to have_content('Add a Pet to this Application')


      within(".add-pet-app") do
        fill_in :search, with: 'Mr. Dog'
        click_button('Search')
        expect(current_path).to eq("/applications/#{@applicant1.id}")
        # save_and_open_page
        expect(page).to have_content(@pet3.name)
        click_button 'Adopt this Pet'
        expect(current_path).to eq("/applications/#{@applicant1.id}")
      end
    end

  describe 'When one or more pets are added to the application' do
    it 'I see a section to submit my application and no mor add more pets' do
      visit "/applications/#{@applicant1.id}"

      within(".submit-app") do
        expect(page).to have_button('Submit Application')
        expect(page).not_to have_content('Add a Pet to this Application')

      end
    end
  end

    it 'I see an input to enter why I would make a good owner for these pet(s)' do
      visit "/applications/#{@applicant1.id}"

      within(".submit-app") do
        expect(page.find_field(:description)).to be_truthy
      end
    end

    it 'I see that the application is "Pending"' do
      visit "/applications/#{@applicant1.id}"

      within(".submit-app") do
        click_button('Submit Application')
      end
      expect(page).to have_content('Pending')
    end
  end
end
