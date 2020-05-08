class DriversController < ApplicationController
  
  # DRIVERS = [
  #   { name: 'Becca',
  #     vin: 12345
  #   },
  #   { name: 'Sharon',
  #     vin: 45678
  #   }
  # ]

  
  def index
    @drivers = Driver.all
  end

  def show

  end
end
