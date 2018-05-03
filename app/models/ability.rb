class Ability
    include CanCan::Ability
    def initialize(user)

        user ||= User.new 
        
        if user.role? :admin
            can :manage, :all
        
        elsif user.role? :instructor
            can :read, Curriculum
            can :read, Location
            can :manage, Camp
            can :students, Camp
            cannot :index, Instructor
            
            can :show, Instructor do |i|
                # byebug
                # i.user_id == user.id
                user.id == i.user_id
            end

            can :update, Instructor do |u|
                user.id == u.user_id
            end

            can :show, User do |u|
                u.id == user.id
            end
            
            can :update, User do |u|
                u.id == user.id
            end
            
            can :read, Student do |s|
                mys = Instructor.where(user_id:user.id).map{|a| a.camps}.flatten.map{|a| a.registrations}.flatten.map{|a| a.student.id}
                mys.include? s.id
            end
            
            can :read, Family do |s|
                mys = Instructor.where(user_id:user.id).map{|a| a.camps}.flatten.map{|a| a.registrations}.flatten.map{|a| a.student.id}
                (mys & s.students.ids).size > 0
            end
        elsif user.role? :parent
            # 4 and 5 
            can :read, Camp
            can :index, Camp
            can :read, Curriculum

            can :students, Camp 
            can :instructors, Camp
            can :add_item, Registration
            can :remove_item, Registration
            can :view_cart, Registration
            can :checkout_cart, Registration

            can :show, Family do |f|
                f.user_id == user.id
            end

            can :update, Family do |f|
                f.user_id == user.id
            end

            can :show, User do |u|
                u.id == user.id
            end

            can :update, User do |u|
                u.id == user.id
            end

            can :manage, Student do |s|
                mys = Family.where(user_id:user.id).first.students.ids
                mys.include? s.id
            end

            can :create, Registration do |s|
                mys = Family.where(user_id:user.id).first.students.ids
                s.payment == nil && mys.include?(s.student.id)
            end
        else
            can :read, Camp
            # can :manage, Student
            # can :manage, Registration
            # can :read, Camp
            can :read, Curriculum
            can :read, Location
            can :read, Instructor
            # can :read, Student
            # can :index, Camp
            can :index, Curriculum
            can :index, Location
            can :show, Location
            can :create, Family
            can :create, User
        end
    end
end
    