class School < ApplicationRecord
  has_many :member_contests, dependent: :destroy

  validates :name_school, uniqueness: true
end
