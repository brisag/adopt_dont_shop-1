require 'rails_helper'

RSpec.describe 'As a visitor' do
  describe 'When I visit the new application page' do
    it 'I can fill in an application' do
      visit '/applications/new'

      fill_in 'name', with: 'Bobby'
      fill_in 'address', with: '123 Main st'
      fill_in 'city', with: 'Denver'
      fill_in 'state', with: 'CO'
      fill_in 'zip_code', with: 80205

      click_button('Submit')

      new_id = Application.last.id
      expect(current_path).to eq("/applications/#{new_id}")

      within("#application-#{new_id}") do
        expect(page).to have_content('Bobby')
        expect(page).to have_content(Application.last.address)
        expect(page).to have_content(Application.last.city)
        expect(page).to have_content(Application.last.state)
        expect(page).to have_content('In Progress')
      end
    end
  end

  describe 'When I visit the new application page' do
    it 'I fail to submit any missing form fields, I see a message' do
      visit '/applications/new'
      click_button('Submit')
      expect(page).to have_content("Error: Required information missing.")
      expect(page).to have_button('Submit')
    end
  end
end
