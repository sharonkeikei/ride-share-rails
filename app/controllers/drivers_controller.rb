class DriversController < ApplicationController
  
  def index
    @drivers = Driver.all
  end

  def show

  end
end
