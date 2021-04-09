class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.search(search_params)
    where("name ILIKE ?", "%#{search_params}%")
  end

  # def self.search(search_params)
  #   where(name: search_params)
  # end

  def self.partial_search(search_params)
    where("name ILIKE ?", "%#{search_params}%")
  end

  def street_address
    "#{address} #{city}, #{state}. #{zip_code}"
  end
end
