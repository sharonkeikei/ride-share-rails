class Driver < ApplicationRecord
  has_many :trips
  validates :name, :vin, presence: true

  def average_rating 
    return nil if self.trips.length == 0

    rating_list = []
    self.trips.each do |trip|
      if trip.rating
        rating_list << trip.rating
      end
    end

    sum = rating_list.sum
    num_trips = rating_list.length

    return (sum/num_trips).round
  end

  def total_earnings
  end
end
