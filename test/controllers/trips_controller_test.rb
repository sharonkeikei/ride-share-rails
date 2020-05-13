require "test_helper"

describe TripsController do

  before do
    @driver = Driver.create(name: "Billy", vin: "59593")
    @passenger = Passenger.create(name: "Betty", phone_num: "123955996932")

    @trip = Trip.new(date: Date.today, cost: 395.00, rating: 3)
    @trip.driver = @driver
    @trip.passenger = @passenger
  end

  describe "show" do
    it "responds with success when showing an existing valid trip" do
      @trip.save

      expect(@trip.valid?).must_equal true
      expect(@trip.errors.messages).must_be_empty

      get trip_path(@trip.id)
      must_respond_with :success
    end

    it "redirects to #homepages if invalid trip id" do
      invalid_id = -1
      get trip_path(invalid_id)
      must_redirect_to homepages_path
    end
  end

  describe "create" do
    it "can create a new trip with valid information accurately, and redirect" do
      new_driver = Driver.create(name: "Roger", vin: "42h34h")
      new_passenger = Passenger.create(name: "Beatrix Lestrange", phone_num: "682828585")
      passenger_id = new_passenger.id

      expect{post passenger_trips_path(passenger_id)}.must_differ "Trip.count", 1
      must_redirect_to passenger_path(passenger_id)
    end

    it "does not create a trip if there are no drivers available; redirects to passenger show page" do
      # set @driver status to false so there are no available drivers
      @driver.update(available: false)
      new_passenger = Passenger.create(name: "Beatrix Lestrange", phone_num: "682828585")
      passenger_id = new_passenger.id

      expect{post passenger_trips_path(passenger_id)}.wont_change "Trip.count"
      must_redirect_to passenger_path(passenger_id)
    end
  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid trip" do
      trip = Trip.create(date: Date.today, cost: 340, rating: 5, driver: @driver, passenger: @passenger)
      get edit_trip_path(trip.id)
      must_respond_with :success
    end

    it "responds with 404 redirect when getting the edit page for a non-existing trip" do
      invalid_trip_id = -1
      get edit_trip_path(invalid_trip_id)
      must_respond_with 404
    end
  end

  describe "update" do
    it "can update a trip with valid information accurately, and redirect" do
      trip = Trip.create(date: Date.today, cost: 5, rating: 2, driver: @driver, passenger: @passenger)

      # new valid info
      trip_param = {
        trip: {
          cost: 123.55,
          rating: 4
        }
      }
 
      expect{patch trip_path(trip.id), params: trip_param}.wont_change "Trip.count"
      trip.reload
      must_redirect_to trip_path(trip.id)
      expect(trip.rating).must_equal trip_param[:trip][:rating]
      expect(trip.cost).must_equal trip_param[:trip][:cost]
    end

    it "doesn't update and redirects to 404 if invalid trip id" do
      invalid_id = -1

      trip_param = {
        trip: {
          cost: 123.55,
          rating: 4
        }
      }
 
      expect{patch trip_path(invalid_id), params: trip_param}.wont_change "Trip.count"
      must_respond_with 404
    end

    it "doesn't update a trip with invalid information" do
      trip = Trip.create(date: Date.today, cost: 5, rating: 2, driver: @driver, passenger: @passenger)

      # new invalid info
      trip_param = {
        trip: {
          cost: nil,
          rating: 4
        }
      }
 
      expect{patch trip_path(trip.id), params: trip_param}.wont_change "Trip.count"
      trip.reload
      expect(trip).must_be_same_as trip
    end
  end

  describe "destroy" do
    it "deletes a trip if the trip is valid" do
      trip = Trip.create(date: Date.today, cost: 5, rating: 2, driver: @driver, passenger: @passenger)
      p "Before delete: #{Trip.count}"
      p "TRIP ID: #{trip.id}"
      before_count = Trip.count
      # delete trip_path(trip.id)
      p "After delete: #{Trip.count}"
      
      expect{delete trip_path(trip.id)}.must_differ "Trip.count", -1
      
      must_redirect_to homepages_path
    end

    it "does not change the db when the trip does not exist, then redirect back to homepage" do
      non_existing_id = -1
      expect{delete trip_path(non_existing_id)}.wont_change 'Trip.count'
      must_redirect_to homepages_path
    end
  end
end
