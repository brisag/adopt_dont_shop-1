class PetApplicationsController < ApplicationController
  def create
    ap = PetApplication.create(pet_app_params)
    redirect_to "/applications/#{params[:application_id]}"
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

  def pet_app_params
   params.permit(:application_id, :pet_id)
  end
end



# def create
#   @applicant = Applicant.find(params[:applicant_id])
#   pet = Pet.find(params[:adopt_pet_id])
#   new_pet_applicant = PetApplicant.create(pet: pet, applicant: @applicant)
#   if new_pet_applicant.save
#     redirect_to "/applicants/#{@applicant.id}"
#   else
#     flash[:notice] = new_pet_applicant.errors.full_messages
#     render 'applicants/show'
#   end
# end
