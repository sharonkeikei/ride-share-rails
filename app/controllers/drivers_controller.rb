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
      flash[:success] = "Driver added successfully"
      redirect_to driver_path(@driver.id)
    else
      render :new
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
      flash[:success] = "Driver updated successfully"
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
    flash[:success] = "Driver removed successfully"
    return
  end

  def toggle_available
    id = params[:id]
    @driver = Driver.find_by(id: id)
    if @driver.available?
      @driver.update(available: false)
      redirect_to driver_path
      flash[:success] = "Driver is no longer available"
    else
      @driver.update(available: true)
      redirect_to driver_path
      flash[:success] = "Yay! Driver is ready to go!"
    end
    return
  end
  
  private

  def driver_params
    return params.require(:driver).permit(:name, :vin)
  end
end
