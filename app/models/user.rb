# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string
#  session_token   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :username, presence: true, uniqueness: true
    validates :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :password, length:{ minimum: 6, allow_null: true }

    def reset_session_token!
        self.session_token = User.generate_session_token
        save!
        session_token
    end

    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def password=(password)
        @password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
                #BCrypt::Password.new(self.password_digest) == BCrypt::Password.create(self.password)
                #does create enhash and new dehash?
                #how exactly does this is_password work?
    end

    def find_by_credentials(username, password)
        @user = User.find_by(username: username)
            return nil if user.nil?
        @user.is_password?(password) ? user : nil
    end

end
