class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :pet_applications
  has_many :applications, through: :pet_applications


  scope :adoptable, -> { where(adoptable: true) }
  scope :adopted,-> { joins(:applications).where("applications.status = 'Approved'")}


  def shelter_name
    shelter.name
  end

  # def self.adoptable
  #   where(adoptable: true)
  # end

  def approve_adoption
    self[:adoptable] = false
    save
  end

  def self.action_required
    joins(pet_applications: :application)
    .where("applications.status = 'Pending'")
    .where("pet_applications.status = 'Pending'")
    .distinct
  end

  def applications_pending
    applications.where("applications.status = 'Pending'")
  end

  def self.adoptable_count
  adoptable.count
end

def self.count_adopted
  adopted.count
end

def self.average_age
  adoptable.average(:age).to_f
end

end
