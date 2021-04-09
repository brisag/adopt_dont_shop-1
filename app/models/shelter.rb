class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy
  has_many :pet_applications, through: :pets
  has_many :applications, through: :pet_applications

  delegate :adoptable_count, to: :pets
  delegate :count_adopted, to: :pets
  delegate :average_age, to: :pets

  scope :adoptable, -> { where(adoptable: true) }
  scope :adopted,-> { joins(:applications).where("applications.status = 'Approved'")}

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def self.desc_by_name
    find_by_sql "SELECT * FROM shelters ORDER BY shelters.name DESC"
  end

  def self.pending_applications
    joins(:applications)
    .where(applications: {status: "Pending"})
    .order(:name)
    .distinct
  end

  def self.shelter_with_name_and_address(id)
    find_by_sql("SELECT name, city FROM shelters WHERE id = #{id}").first
  end

  # def average_age
  #   pets.where(adoptable: true).average(:age).to_f
  # end
  #
  # def adoptable_pet_count
  #   pets.where(adoptable: true).count
  # end
  #
  # def adopted_pet_count
  #   pets.where(adoptable: false).count
  # end

  def action_required_pets
    pets
    .joins(:pet_applications)
    .joins(:applications)
    .where("applications.status = 'Pending'")
  end
end
