class RegistrationsController < ApplicationController
  before_action :set_registration, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource
  
  def index
  end

  def show
  end

  def edit
  end

  def new
  end

  def create
    @registration = Registration.new(registration_params)
    if @student.save
      flash[:notice] = "Successfully registered #{@registration.student.proper_name} for #{@registration.camp.name}."
      redirect_to registration_url
    else
      render action: 'new'
    end
  end

  def update
    if @registration.update_attributes(registration_params)
      flash[:notice] = "Successfully updated #{@registration.student.proper_name}'s registration for #{@registration.camp.name}."
      redirect_to registration_url
    else
      render action: 'edit'
    end
  end

  def destroy
    if @registration.destroy
      redirect_to registration_url, notice: "Successfully removed #{@registration.student.proper_name}'s registration."
    else
      render action: 'show'
    end
  end

  private
    def set_registration
      @registration = Registration.find(params[:id])
    end

    def registration_params
      params.require(:registration).permit(:camp_id, :student_id, :payment)
    end
end
