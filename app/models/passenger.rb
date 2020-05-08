class Passenger < ApplicationRecord
  has_many :trips
  validates :name, :phone_num, presence: true
end
