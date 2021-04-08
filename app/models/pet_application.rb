class PetApplication < ApplicationRecord
  belongs_to :application
  belongs_to :pet
  validates_presence_of :application_id, :pet_id

  # enum status: [:approved, :rejected]

  def reject
    self[:status] = "Reject"
    save
  end

  def approve
    self[:status] = "Approve"
    save
  end


  def approvable?
    pet.adoptable && approved_apps(id, pet.id)
    # pet.adoptable && separately_approved(id, pet.id)

  end

  def approved_apps(id, pet_id)
    PetApplication.joins(:application)
    .where("applications.status='Pending' AND pet_applications.status='Approved'")
    .where("pet_applications.pet_id = ?", pet_id)
    .where("pet_applications.id <> ?", id)
  end
end
