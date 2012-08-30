class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  
  has_many :conversations
  has_many :authentications
  has_many :user_playing
  has_many :conversations, :through => :user_playing
  
  # def conversations
  #   Conversation.where('user1_id = ? or user2_id = ?', self.id, self.id)
  # end
  
  validate :check_phone_length, :if => :active_or_info?
  before_save :check_phone_length, :if => :active_or_info?
  # validate :only_one_active_conversation
  # validate :only_one_waiting_conversation
  
  before_create :add_phone_validator
  # before_validation :set_default_password
  
  validate :check_confirmations, :if => :active_or_info?
  
  validate :check_if_president
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :phone, :user_entered_confirmation, :status,
                  :gender, :year_born, :university_year, :occupation, :studying, :temp_id, :first_name, :last_name,
                  :facebook_link, :location, :uid, :oath_token, :oauth_expires_at, :image, :fb_username, :birthdate,
                  :provider, :relationship_status
  
  validates :email, :uniqueness => true, :if => :active?
  # validates :email, :format => {:with => /^.+@uregina.ca+$/, 
  #                   :message => "We only accept University of Regina Email Adresses. If you are not a
  #                                 UofR student we do not allow access to you."}
  validates :phone, :uniqueness => true, :if => :active?
  validates :phone, :presence => true, :if => :active?
  validates :phone, :format => {:with => /^[\(\)0-9\- \+\.]{10,20}$/,
                                :message => "You must enter an area code."}, :if => :active?
                                
  # validates :gender, :presence => true
  # validates :year_born, :presence => true
  
  UNDERGRAD = 0
  MASTER = 1
  PHD = 2
  STAFF = 3
  PRESIDENT = 4
  OTHER = 5
  
  MALE = 0
  FEMALE = 1
  
  
  def self.from_omniauth(auth, current_us)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      puts 'omnininini'
      puts user
      puts user.email
      
      ed = auth.extra.raw_info.education
      school = ""
      concentration = ""
      ed.each do |e|
        if e.type == 'College'
          # puts e
          puts e
          e.concentration.each do |con|
            puts con.name
            concentration = concentration + con.name + " "
          end
        end
      end

      user.relationship_status = auth.extra.raw_info.relationship_status
      user.provider = auth.provider
      user.birthdate = Date.strptime(auth.extra.raw_info.birthday, '%m/%d/%Y')
      user.fb_username = auth.info.nickname
      user.image = auth.info.image
      user.gender = auth.extra.raw_info.gender
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.oath_token = auth.credentials.token
      user.uid = auth.uid
      user.location = auth.info.location
      user.facebook_link = auth.extra.raw_info.link
      user.studying = concentration
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.status = 'info'
      user.email = current_us.email
      user.password = 'password'
      user.password_confirmation = 'password'
      user.save!
    end
  end

  def add_authentication_values(auth)
    ed = auth.extra.raw_info.education
    school = ""
    concentration = ""
    ed.each do |e|
      if e.type == 'College'
        # puts e
        puts e
        e.concentration.each do |con|
          puts con.name
          concentration = concentration + con.name + " "
        end
      end
    end
    
    self.relationship_status = auth.extra.raw_info.relationship_status
    self.provider = auth.provider
    self.birthdate = Date.strptime(auth.extra.raw_info.birthday, '%m/%d/%Y')
    self.fb_username = auth.info.nickname
    self.image = auth.info.image
    self.gender = auth.extra.raw_info.gender
    self.oauth_expires_at = Time.at(auth.credentials.expires_at)
    self.oath_token = auth.credentials.token
    self.uid = auth.uid
    self.location = auth.info.location
    self.facebook_link = auth.extra.raw_info.link
    self.studying = concentration
    self.first_name = auth.info.first_name
    self.last_name = auth.info.last_name
    self.save!
  end


  def set_default_password
    puts 'setttttting passworddddd'
    self.password = 'password'
    self.password_confirmation = 'password'
  end
  
  def age
    now = Time.now.utc.to_date
    now.year - self.birthdate.year - (self.birthdate.to_date.change(:year => now.year) > now ? 1 : 0)
  end
    
  
  def user_info
    message = "You just connected with a new partner. ("
    message << "#{self.gender?}, " if !self.gender.blank?
    message << "age: #{self.age}, " if !self.birthdate.blank?
    message << "#{self.university_year.ordinalize}, " if !self.university_year.blank?
    message << "studying: #{self.studying.chomp(' ')}" if !self.studying.blank?
    message << "occupation: #{self.occupation?}" if !self.occupation.blank?
    message << ") "
    message << "Say something to get started!"
    message
    # "(#{self.gender?}, age: #{self.age}, studying: #{self.studying.chomp(' ')})"
  end
  
  def talking?
    puts 'checking if the user is currently talking'
    up = UserPlaying.where(:user_id => self.id, :status => 2)
    if !up.empty?
      true
    else
      false
    end
  end
  
  def inactive?
    puts 'checking if the user is currently inactive'
    up = UserPlaying.where("user_id = ? and (status = ? or status = ?)", self.id, 1, 2)
    if !up.empty?
      false
    else
      true
    end
  end
  
  def waiting?
    puts 'checking if user is waiting'
    up = UserPlaying.where("user_id = ? and status = ?", self.id, 1)
    if !up.empty?
      true
    else
      false
    end
  end
        
  def active?
    puts 'isitactive'
    puts status
    status == 'active'                        
  end
  
  def on_beginning_steps?
    !active? && !status.include?("phone")
  end
  
  def active_or_info?
    puts 'activeorinfo'
    puts status
    puts self.status
    active? ||  status.include?("phone")
  end
    
  
  def gender?
    gend = self.gender
    if gend == MALE
      "Male"
    elsif gend == FEMALE
      "Female"
    end
  end
  
  def occupation?
    occ = self.occupation
    puts occ
    if occ == UNDERGRAD
      "Undergraduate Student"
    elsif occ == MASTER
      "Master Student"
    elsif occ == PHD
      "PhD Student"
    elsif occ == STAFF
      "Faculty/Staff"
    elsif occ == PRESIDENT
      "President Dr. Vianne Timmons"
    elsif occ == OTHER
      "other"
    end
  end
      
  
  def add_phone_validator
    confirm = (0...9).map{(rand(20))}.join[0..4]
    while User.find_by_phone_confirm(confirm)
      confirm = (0...9).map{(rand(20))}.join[0..4]
    end
    self.phone_confirm = confirm
  end
  
  def check_if_president
    puts self.occupation
    if self.occupation == 4
      if self.email.downcase != "The.President@uregina.ca".downcase
        errors.add(:occupation, "Whoaaa. If you are actually Dr. Vianne Timmons you would be registering using the email The.President@uregina.ca :p")
        return false
      else
        return true
      end
    end 
  end
  
  def check_confirmations
    puts 'checking the confirmations'
    puts self.status
    puts self.phone_confirm
    puts self.user_entered_confirmation
    if phone_confirm != user_entered_confirmation
      errors.add(:user_entered_confirmation, "The confirmation code entered is incorrect")
      return false
    else
      return true
    end
    # self.phone_confirm == self.user_entered_confirmation
  end
  
  def check_phone_length
    puts 'checking length'
    temp = self.phone
    temp = temp.gsub(/\D/, '')
    puts temp
    puts 'checking length'
    phoneLength = temp.length
    if phoneLength == 10
      temp.insert(0, '1')
    end
    puts temp
    self.phone = temp
  end
  
  def chatting?
    
  end
  
  # attr_accessible :title, :body
end
