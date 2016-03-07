class Goal < ActiveRecord::Base
  validates :title, :user_id, presence: true
  validates :visibility, inclusion: [true, false]
  belongs_to :user

end
