class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource
  # skip_before_action :check_login, only: [:index, :show] 
  def index
    if current_user.role?(:instructor)
      @students = current_user.camps.map {|a| a.students}.flatten.paginate(:page => params[:page]).per_page(12)
    end
  end

  def show
  end

  def edit
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    if logged_in? && current_user.role?(:parent)
      @student.family_id = Family.where(user_id:current_user.id).first.id
      if @student.save
        flash[:notice] = "Successfully added #{@student.proper_name} as a student."
        redirect_to home_path
      else
        render action: 'new'
      end
    end
  end

  def update
    if @student.update_attributes(student_params)
      flash[:notice] = "Successfully updated #{@student.proper_name}."
      redirect_to student_path(@student)
    else
      render action: 'edit'
    end
  end

  def destroy
    if @student.destroy
      redirect_to home_path, notice: "Successfully removed #{@student.proper_name} from the Chess Camp system."
    else
      render action: 'show'
    end
  end

  private
    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:first_name, :last_name, :date_of_birth, :rating, :active)
    end
end
