class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.desc_by_name
  end
end
