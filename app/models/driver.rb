class Driver < ApplicationRecord
  has_many :trips
  validates :name, :vin, presence: true
end
