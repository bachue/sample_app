# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#

require "digest"

class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save :encrypt_password

  validates_presence_of :name, :email
  validates_length_of :name, :maximum => 50
  validates_length_of :password, :within => 6..40
  validates_format_of :email, :with => email_regex
  validates_uniqueness_of :email, :case_sensitive => false
  validates_confirmation_of :password

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password) 
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email email
    user && user.has_password?(submitted_password) ? user : nil
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id id
    (user && user.salt == cookie_salt) ? user : nil
  end

  private
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash "#{salt}--#{string}"
    end

    def make_salt
      secure_hash "#{Time.now.utc}--#{password}"
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest string
    end
end
