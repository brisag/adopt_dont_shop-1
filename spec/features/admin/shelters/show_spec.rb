require 'rails_helper'

RSpec.describe 'As a visitor' do
  describe 'When I visit the admin shelter show page' do
    before :each do
    @shelter1 = Shelter.create!(name: 'Max Fund', city: 'Denver', foster_program: true, rank:4)
    @shelter2 = Shelter.create!(name: 'Dumb Friends', city: 'Boulder', foster_program: true, rank:5)
    @shelter3 = Shelter.create!(name: 'Animal Rescue', city: 'Fort Collins', foster_program: true, rank:4)

    @pet1 = @shelter1.pets.create!(name: 'Francine', breed: 'dog', age: 1, adoptable: true)
    @pet2 = @shelter2.pets.create!(name: 'Joey', breed: 'dog', age: 3, adoptable: true)
    @pet3 = @shelter2.pets.create!(name: 'Mr. Dog', breed: 'cat', age: 10, adoptable: false)
    @pet4 = @shelter2.pets.create!(name: 'Arthur', breed: 'dog', age: 1, adoptable: true)
    @pet5 = @shelter2.pets.create!(name: 'Toy', breed: 'dog', age: 3, adoptable: true)
    @pet6 = @shelter1.pets.create!(name: 'Mrs. Cat', breed: 'cat', age: 10, adoptable: false)

    @applicant1 = Application.create!(name: 'Brisa', address: '123 10th ave', city: 'Denver', state: 'CO', zip_code: 80205, description: "i need cuddly pets", status: "Pending")
    @applicant2 = Application.create!(name: 'John', address: '321 Blake st', city: 'Denver', state: 'CO', zip_code: 80204, description: "i need cute pets", status: "Approved")
    @applicant3 = Application.create!(name: 'Max', address: '1000 Broadway st', city: 'Eerie', state: 'CO', zip_code: 80041, description: "i need funny pets", status: "Pending")
    @applicant4 = Application.create!(name: 'Xotchil', address: '1610 wewatta wy', city: 'Berthoud', state: 'CO', zip_code: 80491, description: "i need smart pets", status: "Approved")

    PetApplication.create!(pet: @pet1, application: @applicant1)
    PetApplication.create!(pet: @pet3, application: @applicant2)
    PetApplication.create!(pet: @pet4, application: @applicant1)
    PetApplication.create!(pet: @pet2, application: @applicant2)

    visit "/admin/shelters/#{@shelter2.id}"
    end

  it "shows the shelter name and address" do
    expect(page).to have_content(@shelter2.name)
      expect(page).to have_content(@shelter2.city)
    end
  end

  it 'I see the average age of all adoptable pets for that shelter' do
    within("#section-stats") do
      expect(page).to have_content(@shelter2.average_age)
    end
  end

  it 'I see the number of pets at that shelter that are adoptable' do
    save_and_open_page

    within("#section-stats") do
      expect(page).to have_content(@shelter2.adoptable_pet_count)
    end
  end

  it 'I see the number of pets that have been adopted from that shelter' do
    within("#section-stats") do
      expect(page).to have_content(@shelter2.adopted_pet_count)
    end
  end
end
