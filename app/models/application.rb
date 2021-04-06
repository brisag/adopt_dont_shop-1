class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications

  validates_presence_of :name, :address, :city, :state, :zip_code

  enum status: ['In Progress', 'Pending', 'Approved', 'Rejected']

  def approve
    if pet_applications.all? {|pet| pet.status=="Approved"}
      self[:status] = "Approved"
      pets.each {|pet| pet.approve_adoption}
      save
    elsif pet_applications.any? {|pet| pet.status=="Rejected"}
      self[:status] = "Rejected"
      save
    end
  end
end
