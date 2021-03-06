class User < ActiveRecord::Base
  rolify
  has_one :profile
  extend FriendlyId

  friendly_id :login

  has_many :events
  has_many :groups
  has_many :photos
  has_many :event_participants
  has_many :joined_events, :through => :event_participants, :source => :event
  has_one :invitation
  
  # Include default devise modules. Others available are:
  # :token_authenticatable
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  validates :login, presence: true, uniqueness: { case_sensitive: false }, format: { with: /^[a-zA-Z0-9_]+$/ }
  validates :email, :password, presence: true

  #async devise mailing with delayed job
  handle_asynchronously :send_reset_password_instructions
  handle_asynchronously :send_confirmation_instructions
  handle_asynchronously :send_on_create_confirmation_instructions

  include Gravtastic
  gravtastic :default => 'mm'

  def confirm!
    super
    UserMailer.delay.welcome_email(self)
  end

  # Build profile on-the-fly
  def profile
    super || build_profile
  end
end
