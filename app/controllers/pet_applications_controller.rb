class PetApplicationsController < ApplicationController
  def create
    PetApplication.create(pet_app_params)
    redirect_to "/applications/#{params[:application_id]}"
    # pet = Pet.find(params[:pet])
    # application = Application.find(params[:id])
    # PetApplication.create(pet: pet, application: application)
    # redirect_to application_path(application)
  end

  # def update
  #
  #   end
    # application = Application.find(params[:application_id])
    # pet_applications = PetApplication.where(application_id: params[:application_id])
    # pet_applications.approve_or_reject(application, params)
    # redirect_to admin_application_path(application)
  # end

  private
  #
  def pet_app_params
   params.permit(:application_id, :pet_id)
  end
end
