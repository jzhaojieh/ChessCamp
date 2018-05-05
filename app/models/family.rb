class Family < ApplicationRecord
  include AppHelpers::Deletions
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods

  # relationships
  belongs_to :user
  has_many :students
  has_many :registrations, through: :students
  attr_accessor :username, :password, :password_confirmation, :email, :phone
  # (:family_name, :parent_first_name, :user_id, :active, :email, :role, :active, :username, :password, :password_confirmation)

  # scopes
  scope :alphabetical, -> { order('family_name') }

  # validations
  validates_presence_of :family_name, :parent_first_name

  # delegates
  delegate :email, to: :user, allow_nil: true
  delegate :phone, to: :user, allow_nil: true
  delegate :username, to: :user, allow_nil: true
  delegate :role, to: :user
  # callbacks
  before_destroy do 
    cannot_destroy_object()
  end

  before_update :handle_family_being_made_inactive
  
  def name 
    self.parent_first_name + ',' + self.family_name
  end

  private
  def handle_family_being_made_inactive
    if self.active == false
      terminate_upcoming_registrations
      make_students_inactive
    end
  end

  def terminate_upcoming_registrations
    self.registrations.select{|r| r.camp.start_date >= Date.current}.each{|r| r.destroy}
  end

  def make_students_inactive
    self.students.each{|s| s.make_inactive}
  end

end
