class TripsController < ApplicationController

  # def index
  #   @trips = Trips.order(:id).all
  # end

  def show
    id = params[:id]
    @trip = Trip.find_by(id: id)

    # redirect to passenger OR driver show page???
    if @trip.nil?
      redirect_to homepages_path, notice: 'Trip not found'
      return
    end
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      flash[:success] = "Trip added successfully"
      redirect_to trip_path(@trip.id)
    else
      render :new
    end
  end

  def edit
    id = params[:id]
    @trip = Trip.find_by(id: id)

    if @trip.nil?
      head :not_found
      return
    end
  end

  def update
    id = params[:id]
    @trip = Trip.find_by(id: id)

    if @trip.nil?
      redirect_to homepages_path, notice: 'Trip not found'
      return
    elsif @trip.update(trip_params)
      redirect_to trip_path(@trip.id)
      flash[:success] = "Trip updated successfully"
      return
    else
      render :edit
      return
    end
  end
  
  def destroy
    id = params[:id]
    @trip = Trip.find_by(id: id)
    if @Trip.nil?
      redirect_to homepages_path, notice: 'Trip not found'
      return
    end

    # what should happen after we delete a trip??
    # go back to previous page??
    @trip.destroy
    redirect_to drivers_path
    flash[:success] = "Trip removed successfully"
    return
  end

  private

  def trip_params
    return params.require(:trip).permit(:cost, :rating, :date)
  end
end
