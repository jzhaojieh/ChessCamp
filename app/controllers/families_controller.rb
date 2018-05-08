class FamiliesController < ApplicationController
  before_action :check_login
  authorize_resource
  before_action :set_family, only: [:show, :edit, :update, :destroy]
  skip_before_action :check_login, only: [:new, :create] 
  include AppHelpers::Cart

  def index
    if current_user.role?(:parent)
      @students = Family.where(user_id:current_user.id).map {|a| a.students}.flatten.paginate(:page => params[:page]).per_page(12)
    end
  end

  def show

  end

  def edit
  end

  def new
    @family = Family.new
  end

  def create
    byebug
    @family = Family.new(family_params)
    @user = User.new(user_params)
    @user.role = 'parent'
    if !@user.save
      @family.valid?
      render action: 'new'
    else
      @family.user_id = @user.id
      if @family.save
        create_cart
        redirect_to login_path, notice: "Account created. Login with the appropriate information"
      else
        render action: 'new'
      end
    end
  end


  def update
    if @family.update(family_params)
      redirect_to home_path, notice: "#{@family.family_name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @family.destroy
    redirect_to family_url, notice: "#{@family.family_name} was deleted from the system."
  end
  
  private
    def set_family
      @family = Family.find(params[:id])
    end

    def family_params
      if current_user.role?(:parent)
        params.require(:family).permit(:phone, :email, :password, :password_confirmation, :family_name, :parent_first_name)
      else
        params.require(:family).permit(:family_name, :parent_first_name, :user_id, :active, :username, :password, :password_confirmation, :username, :password, :password_confirmation, :role, :email, :phone)
      end
    end

    def user_params
      params.require(:family).permit(:username, :password, :password_confirmation, :role, :email, :phone, :active)
    end
end
