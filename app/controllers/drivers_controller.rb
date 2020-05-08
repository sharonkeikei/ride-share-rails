class DriversController < ApplicationController
  
  def index
    @drivers = Driver.order(:id).all
  end

  def show
    id = params[:id]
    @driver = Driver.find_by(id: id)

    if @driver.nil?
      redirect_to drivers_path, notice: 'Driver not found'
      return
    end
  end

  def new
    @driver = Driver.new
  end

  def create
    @driver = Driver.new(driver_params)
    if @driver.save
      redirect_to driver_path(@driver.id)
    else
      render :new, :bad_request
    end
  end

  def edit
    id = params[:id]
    @driver = Driver.find_by(id: id)

    if @driver.nil?
      head :not_found
      return
    end
  end

  def update
    id = params[:id]
    @driver = Driver.find_by(id: id)

    if @driver.nil?
      head :not_found
      return
    elsif @driver.update(driver_params)
      redirect_to driver_path(@driver.id)
      return
    else
      render :edit
      return
    end
  end
  
  def destroy
    id = params[:id]
    @driver = Driver.find_by(id: id)
    if @driver.nil?
      head :not_found
      return
    end

    @driver.destroy
    redirect_to drivers_path
    return
  end

  def toggle_available
    id = params[:id]
    @driver = Driver.find_by(id: id)
    if @driver.available?
      @driver.update(available: false)
      redirect_to driver_path
    else
      @driver.update(available: true)
      redirect_to driver_path
    end
    return
  end
  
  private

  def driver_params
    return params.require(:driver).permit(:name, :vin)
  end
end
