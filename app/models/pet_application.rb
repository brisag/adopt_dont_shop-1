class PetApplication < ApplicationRecord
  belongs_to :application
  belongs_to :pet
  validates_presence_of :application_id, :pet_id

  # enum status: [:approved, :rejected]

  def pet_name
    pet.name
  end

  def reject
    self[:status] = "Reject"
    save
  end

  def approve
    self[:status] = "Approve"
    save
  end
end



  # def self.approve_or_reject(application, params)
  #   if params[:status] == "Approved"
  #     find_application_pet(params[:application_id], params[:pet_id]).update(status: "Approved")
  #   if self.all_pets_approved?
  #     application.approval
  #   end
  # elsif params[:status] == "Rejected"
  #   find_application_pet(params[:application_id], params[:pet_id]).update(status: "Rejected")
  #   if self.any_pets_rejected?
  #     application.rejection
  #   end
  # end
