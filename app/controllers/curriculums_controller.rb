class CurriculumsController < ApplicationController
  before_action :set_curriculum, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  skip_before_action :check_login, only: [:index, :show] 
  authorize_resource
  def index
    @curriculums = Curriculum.all
  end

  def show
    @past_camps_using = @curriculum.camps.past.chronological.paginate(page: params[:page]).per_page(5)
    @upcoming_camps_using = @curriculum.camps.upcoming.chronological.paginate(page: params[:page]).per_page(5)
  end

  def edit
  end

  def new
    @curriculum = Curriculum.new
  end

  def create
    @curriculum = Curriculum.new(curriculum_params)
    if @curriculum.save
      redirect_to curriculum_path(@curriculum), notice: "#{@curriculum.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    @curriculum.update(curriculum_params)
    if @curriculum.save
      redirect_to curriculum_path(@curriculum), notice: "#{@curriculum.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @curriculum.destroy
    redirect_to curriculums_url, notice: "#{@curriculum.name} was removed from the system."
  end

  private
    def set_curriculum
      @curriculum = Curriculum.find(params[:id])
    end

    def curriculum_params
      params.require(:curriculum).permit(:name, :description, :min_rating, :max_rating, :active)
    end
end