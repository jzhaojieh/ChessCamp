
class RegistrationsController < ApplicationController
  # before_action :set_registration, only: [:show, :edit, :update, :destroy]
  include AppHelpers::Cart
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
    byebug
    @cart_regs = get_array_of_ids_for_generating_registrations()
    saved = true
    @cart_regs.each do |i|
      @registration = Registration.new(camp_id: i[0], student_id: i[1])
      unless @registration.valid?
        saved = false
      else
        @registration.pay
      end
    end
    if saved
      clear_cart
      create_cart
    else
      render action: 'checkout_cart'
    end
    # @registration = Registration.new(registration_params)
    # if @registration.save
    #   flash[:notice] = "Successfully registered #{@registration.student.proper_name} for #{@registration.camp.name}."
    #   redirect_to camp_path(@registration.camp)
    # else
    #   flash[:notice] = "Failed to Register. Check ratings are within range"
    #   redirect_to camp_path(@registration.camp)
    #   # render action: 'new', locals: { camp: @camp }
    # end
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

  def add_item
    # byebug
    #check that registration saves 
    add_registration_to_cart(params[:id], params[:registration][:student_id])
    flash[:notice] = "Registration has been added to your cart!"
    redirect_to camp_path(Camp.where(id:params[:id]).first)
    # redirect_to view_cart_url, notice: "Registration has been removed from your cart!"
  end

  def remove_item
    remove_registration_from_cart(params[:id], params[:registration][:student_id])
    redirect_to view_cart_url, notice: "Registration has been removed from your cart!"
  end

  def view_cart
    @cart_regs = get_array_of_ids_for_generating_registrations
    # @cart_cost = calculate_total_cart_registration_cost
  end

  # def checkout_cart
  #   @order = Order.new
  #   @cart_order_items = get_list_of_items_in_cart
  #   @cart_subtotal = calculate_cart_items_cost
  #   if logged_in? && current_user.role?(:customer)
  #       @customer_id = current_user.customer.id
  #   elsif logged_in? && current_user.role?(:admin)
  #       @customer_id = current_user.id
  #   else
  #   end 
  # end

  private
    def registration_params
      params.require(:registration).permit(:camp_id, :student_id, :payment, :credit_card_number, :expiration_year, :expiration_month)
    end
end
