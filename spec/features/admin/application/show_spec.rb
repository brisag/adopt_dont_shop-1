require 'rails_helper'

RSpec.describe 'As a visitor' do
  describe 'When I visit the admin application show page' do
    before :each do
      @shelter1 = Shelter.create!(name: 'Max Fund', city: 'Denver', foster_program: true, rank:4)
      @shelter2 = Shelter.create!(name: 'Dumb Friends', city: 'Boulder', foster_program: true, rank:5)
      @shelter3 = Shelter.create!(name: 'Animal Rescue', city: 'Fort Collins', foster_program: true, rank:4)

      @pet1 = @shelter1.pets.create!(name: 'Francine', breed: 'dog', age: 1, adoptable: true)
      @pet2 = @shelter2.pets.create!(name: 'Joey', breed: 'dog', age: 3, adoptable: true)
      @pet3 = @shelter1.pets.create!(name: 'Mr. Dog', breed: 'cat', age: 10, adoptable: true)
      @pet4 = @shelter1.pets.create!(name: 'Arthur', breed: 'dog', age: 1, adoptable: true)
      @pet5 = @shelter2.pets.create!(name: 'Toy', breed: 'dog', age: 3, adoptable: true)
      @pet6 = @shelter1.pets.create!(name: 'Mrs. Cat', breed: 'cat', age: 10, adoptable: true)

      @applicant1 = Application.create!(name: 'Brisa', address: '123 10th ave', city: 'Denver', state: 'CO', zip_code: 80205, description: "i need cuddly pets")
      @applicant2 = Application.create!(name: 'John', address: '321 Blake st', city: 'Denver', state: 'CO', zip_code: 80204, description: "i need cute pets")
      @applicant3 = Application.create!(name: 'Max', address: '1000 Broadway st', city: 'Eerie', state: 'CO', zip_code: 80041, description: "i need funny pets")
      @applicant4 = Application.create!(name: 'Xotchil', address: '1610 wewatta wy', city: 'Berthoud', state: 'CO', zip_code: 80491, description: "i need smart pets")

      PetApplication.create!(pet: @pet1, application: @applicant1)
      PetApplication.create!(pet: @pet1, application: @applicant2)
      PetApplication.create!(pet: @pet2, application: @applicant1)
      PetApplication.create!(pet: @pet2, application: @applicant2)

      visit "/admin/applications/#{@applicant1.id}"
    end

    it "There is a button with approve and when I click that button, am taken to the admin application show page and see an indicator its approved" do
      within("#admin-applicant-#{@applicant1.id}") do
        within("#pet-#{@pet1.id}") do
          click_button('Approve')
        end
        expect(current_path).to eq("/admin/applications/#{@applicant1.id}")
      end
    end

    it "next to every pet, it has button to REJECT the application for that specific pet" do
      within("#admin-applicant-#{@applicant1.id}") do
        expect(page).to have_button('Reject')
      end
    end

    it "I click that button, am taken to the admin application show page and see and indicator its been rejected" do
      within("#admin-applicant-#{@applicant1.id}") do
        within("#pet-#{@pet1.id}") do
          click_button('Reject')
        end
        expect(current_path).to eq("/admin/applications/#{@applicant1.id}")
      end
    end

    it "if i go to any other show page, even if i accept/reject same pet for anothe app, i can still see accept/reject buttons" do
      within("#admin-applicant-#{@applicant1.id}") do
        within("#pet-#{@pet1.id}") do
          click_button('Approve')
        end
      end

      visit "/admin/applications/#{@applicant2.id}"

      @applicant2.pets.each do |pet|
        within("#pet-#{pet.id}") do
          expect(page).to have_button('Approve')
          expect(page).to have_button('Reject')
        end
      end
    end

    describe 'I visit the admin application show page for one of the applications' do
      it 'I approve the pet for that application and I see buttons to approve or reject on the other application' do
        visit "/admin/applications/#{@applicant1.id}"

        within("#admin-applicant-#{@applicant1.id}") do
          within("#pet-#{@pet1.id}") do
            click_button('Approve')
          end
        end

        visit "/admin/applications/#{@applicant2.id}"

        @applicant2.pets.each do |pet|
          within("#pet-#{pet.id}") do
            expect(page).to have_button('Approve')
            expect(page).to have_button('Reject')
          end
        end
      end

      it 'I reject the pet for that application' do
        visit "/admin/applications/#{@applicant1.id}"

        within("#admin-applicant-#{@applicant1.id}") do
          within("#pet-#{@pet1.id}") do
            click_button('Reject')
          end
        end

        visit "/admin/applications/#{@applicant2.id}"

        within("#admin-applicant-#{@applicant2.id}") do
          expect(page).to have_button('Approve')
          expect(page).to have_button('Reject')
        end
      end
    end

    describe 'When I approve all pets for an application' do
      it 'I see the applications status has changed to "Accepted" on the application show page' do
        visit "/admin/applications/#{@applicant2.id}"

        within("#admin-applicant-#{@applicant2.id}") do
          within("#pet-#{@pet1.id}") do
            click_button('Approve')
          end

          within("#pet-#{@pet2.id}") do
            click_button('Approve')
          end
          expect(page).to have_content('Accepted')
        end
      end
    end

    describe 'When I reject one pet for an application' do
      it 'I see the applications status has changed to "Accepted" on the application show page' do
        visit "/admin/applications/#{@applicant2.id}"

        within("#admin-applicant-#{@applicant2.id}") do
          within("#pet-#{@pet1.id}") do
            click_button('Reject')
          end
          expect(page).to have_content('Rejected')
        end
      end
    end

    describe 'When application is accepted and I visit the show pages for those pets' do
      it 'I see that those pets are no longer "adoptable"' do
        visit "/admin/applications/#{@applicant1.id}"

        within("#admin-applicant-#{@applicant1.id}") do
          within("#pet-#{@pet1.id}") do
            click_button('Approve')
          end
          within("#pet-#{@pet2.id}") do
            click_button('Approve')
          end
        end

        @applicant1.pets.each do |pet|
          visit "/pets/#{pet.id}"
          expect(page).to have_content('Adoption Status: false')
          # expect(pet.adoptable?).to be_falsy
        end
      end
    end

    describe 'When application is rejected and I visit the show pages for those pets' do
      it 'I see that those pets are still "adoptable"' do
        visit "/admin/applications/#{@applicant1.id}"

        within("#admin-applicant-#{@applicant1.id}") do
          within("#pet-#{@pet1.id}") do
            click_button('Reject')
          end
          within("#pet-#{@pet2.id}") do
            click_button('Reject')
          end
        end

        @applicant1.pets.each do |pet|
          visit "/pets/#{pet.id}"
          expect(page).to have_content('Adoption Status: true')
          expect(pet.adoptable).to be_truthy
        end
      end
    end


    describe 'When a pet has an "Approved" application on them' do
      describe 'I visit the admin application show page for the "Pending" application' do
        it 'I see a message that this pet has been approved for adoption' do
          visit "/admin/applications/#{@applicant1.id}"

          within("#admin-applicant-#{@applicant1.id}") do
            within("#pet-#{@pet1.id}") do
              click_button('Approve')
            end
            within("#pet-#{@pet2.id}") do
              click_button('Approve')
            end
          end

          visit "/admin/applications/#{@applicant2.id}"

          within("#admin-applicant-#{@applicant2.id}") do
            within("#pet-#{@pet1.id}") do
              expect(page).to have_content('No longer adoptable.')
              expect(page).not_to have_button('Approve')
            end
          end
        end

        it 'I do see a button to reject them' do
          visit "/admin/applications/#{@applicant1.id}"

          within("#admin-applicant-#{@applicant1.id}") do
            within("#pet-#{@pet1.id}") do
              click_button('Approve')
            end
            within("#pet-#{@pet2.id}") do
              click_button('Approve')
            end
          end

          visit "/admin/applications/#{@applicant2.id}"

          within("#admin-applicant-#{@applicant2.id}") do
            within("#pet-#{@pet1.id}") do
              expect(page).to have_button('Reject')
            end
          end
        end
      end
    end
  end
end
