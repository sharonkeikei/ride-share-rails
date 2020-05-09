class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  validates :date, :cost, :rating, presence: true
end
