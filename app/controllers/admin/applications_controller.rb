class Admin::ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

  def update
    application = Application.find(params[:id])
    PetApplication.find_by(application_id: application, pet_id: params[:pet]).send(params[:status])
    application.approve
    redirect_to admin_application_path(application)
  end
end
