class Admin::ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

  def update
    pet_application = PetApplication.find(params[:id])
    pet_application.update(status: params[:status])
    redirect_to admin_application_path(pet_application.application_id)
  end
end
