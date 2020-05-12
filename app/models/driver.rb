class Driver < ApplicationRecord
  has_many :trips,  dependent: :destroy
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
    return 0 if self.trips.length == 0

    earnings_list = []
    self.trips.each do |trip|
      earnings_list << ((trip.cost - 1.65) * 0.8)
    end

    return earnings_list.sum.round(2)
  end
end
