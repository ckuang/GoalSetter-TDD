FactoryGirl.define do
  factory :user do
    username 'thechuckmeista'
    password_digest BCrypt::Password.create('starwars')
    password 'starwars'
    session_token SecureRandom.urlsafe_base64(16)
  end
end
