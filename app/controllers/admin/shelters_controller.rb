class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.desc_by_name
    @shelters_with_pending_apps = Shelter.pending_applications
  end
end
