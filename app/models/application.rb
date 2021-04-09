class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications

  validates_presence_of :name, :address, :city, :state, :zip_code

  # enum status: [:in_progress, :pending, :approved, :rejected]
  # scope :pending,-> { where(status: "Pending")}
    def approve
      if pet_applications.all? {|pet| pet.status=="Approve"}
        self[:status] = "Approve"
        pets.each {|pet| pet.approve_adoption}
        save
      elsif pet_applications.any? {|pet| pet.status=="Rejected"}
        self[:status] = "Rejected"
        save
      end
    end
  end
  # def status_update
  #   if all_pets_approved
  #     update(status: "Approved")
  #     pets.approve_adoption
  #   elsif any_pets_rejected
  #     update(status: "Rejected")
  #   end
  # end
  #
  # def all_pets_approved
  #   pet_applications.all? {|pet_app| pet_app.status=="Approved"}
  # end
  #
  # def any_pets_rejected
  #   pet_applications.any? {|pet_app| pet_app.status=="Rejected"}
  # end


  # def self.already_adopted
  #   pending.where("pet_applications.status='approved'").exists?
  # end
# end
