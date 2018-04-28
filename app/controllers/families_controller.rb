class FamiliesController < ApplicationController
  before_action :check_login
  authorize_resource
  before_action :set_family, only: [:show, :edit, :update, :destroy]

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
    @family = Family.new(family_params)
    @user = User.new(user_params)
    @user.role = 'parent'
    if !@user.save
      @family.valid?
      render action: 'new'
    else
    @family.user_id = @user.id
    if @family.save
      redirect_to family_path(@family), notice: "#{@family.family_name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @family.update(family_params)
      redirect_to family_path(@family), notice: "#{@family.family_name} was revised in the system."
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
      params.require(:family).permit(:family_name, :parent_first_name, :user_id, :active)
    end

    def user_params
      params.require(:owner).permit(:first_name, :last_name, :active, :username, :password, :password_confirmation)
    end
end
