class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :current_password
  before_save :downcase_email
  before_create :create_activation_digest
  has_many :microposts, dependent: :destroy


  validates(:name,presence:true,length:{maximum:50})
  $VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates(:email,presence:true,length:{maximum:255},
            format: {with:$VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false});

  has_secure_password
  validates :password, presence: true, length: { minimum: 7 }, allow_nil: true

  def activate
    update_columns(activated:true,activated_at:Time.zone.now)
  end

  def feed
    Micropost.all
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)

  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest") #this is v. cool
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  private

    def downcase_email
      self.email.downcase! #"bang" operator applies method to self and updates
    end
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(self.activation_token)
    end

end
