# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates_presence_of :name, :email
  validates_length_of :name, :maximum => 50
  validates_length_of :password, :within => 6..40
  validates_format_of :email, :with => email_regex
  validates_uniqueness_of :email, :case_sensitive => false
  validates_confirmation_of :password

  private
    def encrypt_password
      self.encrypted_password = encrypt password
    end

    def encrypt(string)
      string
    end
end
