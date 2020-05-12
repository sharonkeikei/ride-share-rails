class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  validates :date, :cost, presence: true

  def self.request_trip
    assigned_driver = Driver.find_first_available

    new_trip_params = {
      date: Date.today,
      cost: (rand * (2000-5) + 5).round(2),
      driver: assigned_driver
    }
    # if there is no available driver, driver will be nil and won't let pax 
    # request trip and won't update any driver status
    if assigned_driver
      assigned_driver.update(available: false)
    end

    return new_trip_params
  end
end
