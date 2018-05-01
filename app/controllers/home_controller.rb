class HomeController < ApplicationController
  def index
    if logged_in? && current_user.role?(:parent)
      unless Family.where(user_id: current_user.id).empty?
        @active_students = Family.where(user_id: current_user.id).first.students.alphabetical.active.paginate(:page => params[:page]).per_page(12)
        @inactive_students = Family.where(user_id: current_user.id).first.students.alphabetical.inactive.paginate(:page => params[:page]).per_page(12)
        @upcoming_camps = Camp.upcoming.where.not(id: Camp.upcoming.full).where(curriculum_id: Family.where(user_id: current_user.id).first.students.map{|a| a.rating}.map {|r| Curriculum.for_rating(r)}.map{|d| d.ids}.flatten).chronological.paginate(:page => params[:page]).per_page(5)
      end
    elsif logged_in? && current_user.role?(:admin)
      @s_camps = Camp.empty.chronological.paginate(:page => params[:page]).per_page(12)
      @s_locations = Location.where(id: Camp.empty.map{|a| a.location_id}).alphabetical.paginate(:page => params[:page]).per_page(12)
      @counts = Hash.new
      # maybe add to model method
      Camp.empty.map {|a| a.location.id}.each {|b| @counts[b] = 0}
      Camp.empty.map {|a| a.location.id}.each {|b| @counts[b] = @counts[b] + 1}
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
  
end