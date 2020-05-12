class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  validates :date, :cost, presence: true

  def self.request_trip
    assigned_driver = Driver.find_first_available

    new_trip_params = {
      date: Date.today,
      cost: (rand * (2000-5) + 5).round(2),
      driver_id: assigned_driver.id
    }

    assigned_driver.update(available: false)
    return new_trip_params
  end
end
