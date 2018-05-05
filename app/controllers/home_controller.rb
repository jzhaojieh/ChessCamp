class HomeController < ApplicationController
  def index
    if logged_in? && current_user.role?(:parent)
      unless Family.where(user_id: current_user.id).empty?
        @active_students = Family.where(user_id: current_user.id).first.students.alphabetical.paginate(:page => params[:page]).per_page(5)
        @inactive_students = Family.where(user_id: current_user.id).first.students.alphabetical.inactive.paginate(:page => params[:page]).per_page(5)
        @upcoming_camps = Camp.upcoming.where.not(id: Camp.upcoming.full).where(curriculum_id: Family.where(user_id: current_user.id).first.students.map{|a| a.rating}.map {|r| Curriculum.for_rating(r)}.map{|d| d.ids}.flatten).chronological.paginate(:page => params[:page]).per_page(5)
        @reg_camps2 = Registration.where(id: Family.where(user_id: current_user.id).first.students.map {|a| a.registrations.ids}.flatten).alphabetical.paginate(:page => params[:page]).per_page(5)
        @student = Student.new
      end
    elsif logged_in? && current_user.role?(:admin)
      @s_camps = Camp.empty.chronological.paginate(:page => params[:page]).per_page(5)
      @r_camps = Camp.where.not(id:  CampInstructor.all.map{|a| a.camp.id}).chronological.paginate(:page => params[:page]).per_page(5)
      @s_locations = Location.where(id: Camp.empty.map{|a| a.location_id}).alphabetical.paginate(:page => params[:page]).per_page(5)
      @counts = Hash.new
      # maybe add to model method
      Camp.empty.map {|a| a.location.id}.each {|b| @counts[b] = 0}
      Camp.empty.map {|a| a.location.id}.each {|b| @counts[b] = @counts[b] + 1}
      @regs = Registration.all.group(:student_id).map{|a| a.family.id}
      @rcounts = Hash.new
      @regs.each {|b| @rcounts[b] = 0}
      @regs.each {|b| @rcounts[b] = @rcounts[b] + 1}
      @fams = @rcounts.sort_by{|k, v| v}.reverse.map {|a| Family.where(id:a[0]).first}
      # @famss = Family.where(id: @fams.map{|c| c.id}).paginate(:page => params[:page]).per_page(5)
    elsif logged_in? && current_user.role?(:instructor)
      @i_camps = Instructor.where(user_id:current_user.id).first.camps.upcoming.chronological.paginate(:page => params[:page]).per_page(5)
    end
  end

  def about
  end

  def contact
  end

  def privacy
  end
  
  def search
    @query = params[:query]
    @curriculums = Curriculum.search(@query)
    @instructors = Instructor.search(@query)
    @total_hits = @curriculums.size + @instructors.size
  end
end