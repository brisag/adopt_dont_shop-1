class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :pet_applications
  has_many :applications, through: :pet_applications


  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def approve_adoption
    self[:adoptable] = false
    save
  end

  def self.action_required
    joins(pet_applications: :application)
    .where("applications.status = 'Pending'")
    .where("pet_applications.status = 'Pending'")
  end
end
