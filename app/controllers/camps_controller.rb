class CampsController < ApplicationController
  before_action :set_camp, only: [:show, :edit, :update, :destroy, :instructors, :students]
  before_action :check_login
  skip_before_action :check_login, only: [:index, :show] 
  authorize_resource
  def index
    @active_camps = Camp.all.active.alphabetical.paginate(:page => params[:active_camps]).per_page(10)
    @inactive_camps = Camp.all.inactive.alphabetical.paginate(:page => params[:inactive_camps]).per_page(1)
  end

  def show
    @instructors = @camp.instructors.alphabetical
    if logged_in? && current_user.role?(:parent) && (Family.where(user_id:current_user.id).empty? == false)
      @students = Family.where(user_id:current_user.id).first.students.alphabetical
    else
      @students = @camp.students.alphabetical
    end
  end

  def edit
  end

  def new
    @camp = Camp.new
  end

  def create
    @camp = Camp.new(camp_params)
    if @camp.save
      redirect_to camp_path(@camp), notice: "#{@camp.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    @camp.update(camp_params)
    if @camp.save
      redirect_to camp_path(@camp), notice: "#{@camp.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @camp.destroy
    redirect_to camps_url, notice: "#{@camp.name} was removed from the system."
  end

  def instructors
    @instructors = Instructor.for_camp(@camp).alphabetical
  end

  def students
    if current_user.role?(:parent) || current_user.role?(:admin) || current_user.role?(:instructor)
      @students = Camp.where(id: @camp.id).first.students.alphabetical
    end
  end

  private
    def set_camp
      @camp = Camp.find(params[:id])
    end

    def camp_params
      params.require(:camp).permit(:curriculum_id, :location_id, :cost, :start_date, :end_date, :time_slot, :max_students, :active)
    end
end