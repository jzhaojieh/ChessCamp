class HomeController < ApplicationController
  def index
    if logged_in? && current_user.role?(:parent)
      unless Family.where(user_id: current_user.id).empty?
        @active_students = Family.where(user_id: current_user.id).first.students.active.paginate(:page => params[:page]).per_page(12)
        @inactive_students = Family.where(user_id: current_user.id).first.students.inactive.paginate(:page => params[:page]).per_page(12)
      end
    end
  end

  def about
  end

  def contact
  end

  def privacy
  end
  
end