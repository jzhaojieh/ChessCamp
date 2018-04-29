class Ability
    include CanCan::Ability
    def initialize(user)
        user ||= User.new 
        
        if user.role? :admin
            can :manage, :all
        
        elsif user.role? :instructor
            can :read, Curriculum
            can :read, Location
            can :read, Camp
            
            can :update, Instructor do |u|  
                u.id == Instructor.where(user_id:user.id).first.id
            end
            
            can :read, Student do |s|
                mys = Family.where(user_id:user.id).map{|a| a.students.ids}.flatten
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
            can :index, Curriculum
            
            can :update, User do |u|
                u.id == user.id
            end
            can :manage, Student do |s|  
                s.id == student.id
            end
            can :manage, Student 
            #CANNOT MANAGE CAMP
            can :manage, Camp 
            # can :manage, :all
            can :manage, Registration do |s|
                s.payment == nil
            end
        else
            can :read, Camp
            can :read, Curriculum
            can :read, Location
            can :index, Camp
            can :index, Curriculum
            can :index, Location
            can :create, Family
            can :create, User
        end
    end
end
    