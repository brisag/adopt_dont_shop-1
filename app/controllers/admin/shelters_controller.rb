class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.desc_by_name
    @shelters_with_pending_apps = Shelter.pending_applications
  end

  def show
    @shelter = Shelter.find(params[:id])
    @shelter_information = Shelter.shelter_with_name_and_address(params[:id])
  end
end
