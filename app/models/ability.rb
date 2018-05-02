class Ability
    include CanCan::Ability
    def initialize(user)
        user ||= User.new 
        
        if user.role? :admin
            can :manage, :all
            # can :manage, Registration
        
        elsif user.role? :instructor
            can :read, Curriculum
            can :read, Location
            can :manage, Camp
            cannot :update, Camp
            cannot :destroy, Camp
            
            can :read, Instructor do |u|
                u.id == Instructor.where(user_id:user.id).first.id
            end
            can :update, Instructor do |u|
                u.id == Instructor.where(user_id:user.id).first.id
            end

            can :manage, User do |u|
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
            #CANNOT MANAGE CAMP WTf
            can :manage, Camp 
            cannot :update, Camp
            cannot :destroy, Camp

            can :add_item, Registration

            can :read, Curriculum
            can :index, Curriculum
            
            can :update, User do |u|
                u.id == user.id
            end

            can :manage, Student do |s|  
                mys = Family.where(user_id:user.id).first.students.ids
                mys.include? s.id
            end

            can :manage, Registration do |s|
                mys = Family.where(user_id:user.id).first.students.ids
                s.payment == nil && mys.include?(s.student.id)
            end

            can :manage, Family do |f|
                f.user_id == user.id
            end

        else
            can :manage, Camp
            cannot :update, Camp
            cannot :destroy, Camp
            can :manage, Student
            can :manage, Registration
            # can :read, Camp
            can :read, Curriculum
            can :read, Location
            can :read, Instructor
            # can :read, Student
            # can :index, Camp
            can :index, Curriculum
            can :index, Location
            can :create, Family
            can :create, User
        end
    end
end
    