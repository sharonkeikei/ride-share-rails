class PassengersController < ApplicationController

  def index
    @passengers = Passenger.order(:id).all
  end

  def show
    id = params[:id]
    @passenger = Passenger.find_by(id: id)

    if @passenger.nil?
      redirect_to passengers_path, notice: 'Passenger not found'
      return
    end
  end

  def new
    @passenger = Passenger.new
  end

  def create
    @passenger = Passenger.new(passenger_params)
    if @passenger.save
      flash[:success] = "Passenger added successfully"
      redirect_to passenger_path(@passenger.id)
    else
      render :new
    end
  end

  def edit
    id = params[:id]
    @passenger = Passenger.find_by(id: id)

    if @passenger.nil?
      redirect_to passengers_path, notice: 'Passenger not found'
      return
    end
  end

  def update
    id = params[:id]
    @passenger = Passenger.find_by(id: id)

    if @passenger.nil?
      head :not_found
      return
    elsif @passenger.update(passenger_params)
      redirect_to passenger_path(@passenger.id)
      flash[:success] = "Passenger updated successfully"
      return
    else
      render :edit
      return
    end
  end
  
  def destroy
    id = params[:id]
    @passenger = Passenger.find_by(id: id)
    if @passenger.nil?
      redirect_to passengers_path, notice: 'Passenger not found'
      return
    end

    @passenger.destroy
    redirect_to passengers_path
    flash[:success] = "Passenger removed successfully"
    return
  end
  
  private

  def passenger_params
    return params.require(:passenger).permit(:name, :phone_num)
  end
end
