class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  
  has_many :conversations
  
  def conversations
    Conversation.where('user1_id = ? or user2_id = ?', self.id, self.id)
  end
  
  before_create :check_phone_length, :if => :active?
  before_create :add_phone_validator
  before_save :check_confirmations, :if => :active?
  
  validate :check_if_president
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :phone, :user_entered_confirmation, :status,
                  :gender, :year_born, :university_year, :occupation, :studying
  
  validates :email, :uniqueness => true, :if => :active?
  # validates :email, :format => {:with => /^.+@uregina.ca+$/, 
  #                   :message => "We only accept University of Regina Email Adresses. If you are not a
  #                                 UofR student we do not allow access to you."}
  validates :phone, :uniqueness => true, :if => :active?
  validates :phone, :presence => true, :if => :active?
  validates :phone, :format => {:with => /^[\(\)0-9\- \+\.]{10,20}$/,
                                :message => "You must enter an area code."}, :if => :active?
                                
  validates :gender, :presence => true
  validates :year_born, :presence => true
  
  UNDERGRAD = 0
  MASTER = 1
  PHD = 2
  STAFF = 3
  PRESIDENT = 4
  OTHER = 5
  
  MALE = 0
  FEMALE = 1

        
  def active?
    status == 'active'                        
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
    confirm = (0...9).map{65.+(rand(20))}.join[0..4]
    while User.find_by_phone_confirm(confirm)
      confirm = (0...9).map{65.+(rand(20))}.join[0..4]
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
  
  # attr_accessible :title, :body
end
