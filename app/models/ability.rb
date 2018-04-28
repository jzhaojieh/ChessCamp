class Ability
    include CanCan::Ability
    def initialize(user)
        user ||= User.new 
        
        if user.role? :admin
            can :manage, :all
        
        elsif user.role? :instructor
            can :index, Curriculum
            
            can :update, Instructor do |u|  
                u.id == :instructor.id
            end
            
            can :read, Student do |s|
                mys = Family.where(user_id:user.id).map{|a| a.students.ids}.flatten
                mys.include? s.id
            end

            can :read, Family do |s|
                mys = Instructor.where(user_id:user.id).map{|a| a.camps}.flatten.map{|a| a.registrations}.flatten.map{|a| a.student.id}
                mys.include? s.id
            end
            
        elsif user.role? :parent
            # 4 and 5 
            can :show, Camp
            can :show, Curriculum
            
            can :manage, Student do |s|  
                s.id == student.id
            end
            
            can :create, Registration 
            can :show, Order
        else
            can :read, Camp
            can :read, Curriculum
            can :create, Family
            can :create, User
        end
    end
end
    