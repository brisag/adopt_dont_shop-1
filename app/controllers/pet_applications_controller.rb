class PetApplicationsController < ApplicationController
  def create
    ap = PetApplication.create(pet_app_params)
    redirect_to "/applications/#{params[:application_id]}"
  end

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
