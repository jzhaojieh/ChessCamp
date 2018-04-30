require 'byebug'
class RegistrationsController < ApplicationController
  # before_action :set_registration, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource
  
  
  def index
  end

  def show
  end

  def edit
  end

  def new
    @registration = Registration.new
    @camp = Camp.find(params[:camp_id])
  end

  def create
    @registration = Registration.new(registration_params)
    if @registration.save
      flash[:notice] = "Successfully registered #{@registration.student.proper_name} for #{@registration.camp.name}."
      redirect_to camp_path(@registration.camp)
    else
      flash[:notice] = "Failed to Register. Check ratings are within range"
      redirect_to camp_path(@registration.camp)
      # render action: 'new', locals: { camp: @camp }
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
    camp_id = params[:id]
    student_id = params[:student_id]
    @registration = Registration.where(camp_id: camp_id, student_id: student_id).first
    unless @registration.nil?
      @registration.destroy 
      flash[:notice] = "Successfully removed this registration."
      redirect_to camp_path(@registration.camp)
    end
  end

  private
    def registration_params
      params.require(:registration).permit(:camp_id, :student_id, :payment)
    end
end
