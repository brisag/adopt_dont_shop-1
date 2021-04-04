class ApplicationsController < ApplicationController
  def index
    @applications =Application.all
  end

  def new
  end

  def create
    @application = Application.new(application_params)
    if @application.save
      redirect_to "/applications/#{@application.id}"
    else
      flash[:notice] = "Error: Required information missing."
      render :new
    end
  end

  def show
    @application = Application.find(params[:id])
    if params[:search]
      @pets = Pet.search(params[:search])
    end
  end

  private

  def application_params
    params.permit(:name, :address, :city, :state, :zip_code, :description, :status)
  end
end
