require "test_helper"

describe Driver do
  let (:new_driver) {
    Driver.new(name: "Kari", vin: "123", available: true)
  }
  it "can be instantiated" do
    # Assert
    expect(new_driver.valid?).must_equal true
  end

  it "will have the required fields" do
    # Arrange
    new_driver.save
    driver = Driver.first
    [:name, :vin, :available].each do |field|

      # Assert
      expect(driver).must_respond_to field
    end
  end

  describe "relationships" do
    it "can have many trips" do
      # Arrange
      new_driver.save
      new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
      trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1234)
      trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)

      # Assert
      expect(new_driver.trips.count).must_equal 2
      new_driver.trips.each do |trip|
        expect(trip).must_be_instance_of Trip
      end
    end
  end

  describe "validations" do
    it "must have a name" do
      # Arrange
      new_driver.name = nil

      # Assert
      expect(new_driver.valid?).must_equal false
      expect(new_driver.errors.messages).must_include :name
      expect(new_driver.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "must have a VIN number" do
      # Arrange
      new_driver.vin = nil

      # Assert
      expect(new_driver.valid?).must_equal false
      expect(new_driver.errors.messages).must_include :vin
      expect(new_driver.errors.messages[:vin]).must_equal ["can't be blank"]
    end
  end

  # Tests for methods you create should go here
  describe "custom methods" do
      
      before do
        # Make a driver with trips
        @kari_driver = Driver.new(name: "Kari", vin: "123", available: true)
        @kari_driver.save
        @kari_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
        @trip_1 = Trip.create(driver_id: @kari_driver.id, passenger_id: @kari_passenger.id, date: Date.today, rating: 5, cost: 1234)
        @trip_2 = Trip.create(driver_id: @kari_driver.id, passenger_id: @kari_passenger.id, date: Date.today, rating: 3, cost: 6334)
        
        # Make driver without trips
        @no_trips_driver = Driver.new(name: "Henry", vin: "456", available: true)
        @no_trips_driver.save
      end

    describe "average rating" do

      it "returns nil if driver has not driven any trips" do
        expect(@no_trips_driver.trips.length).must_equal 0
        expect(@no_trips_driver.average_rating).must_be_nil
      end

      it "accesses all the driver's trips for a driver with trips already driven" do
        expect(@kari_driver.trips.length).must_equal 2
      end

      it "correctly computes the average rating" do
        expect(@kari_driver.average_rating).must_equal 4
      end

      it "correctly computes average when another trip is added" do
        expect(@kari_driver.trips.length).must_equal 2

        # Add a new trip
        @trip_3 = Trip.create(driver_id: @kari_driver.id, passenger_id: @kari_passenger.id, date: Date.today, rating: 2, cost: 5)
        @kari_driver.reload
        expect(@kari_driver.trips.length).must_equal 3
        # round average rating to nearest integer
        expect(@kari_driver.average_rating).must_equal 3
      end
    end

    describe "total earnings" do
      # Your code here
      it "return 0 if driver has not driven any trip" do
        expect(@no_trips_driver.total_earnings).must_equal 0
      end

      it 'correctly return the correct total earnings if driver has driven' do
        expect(@kari_driver.total_earnings).must_equal 6051.76
      end

      it 'will add the new trip earning after a new trip is completed' do
        @trip_3 = Trip.create(driver_id: @kari_driver.id, passenger_id: @kari_passenger.id, date: Date.today, rating: 2, cost: 5)
        @kari_driver.reload
        expect(@kari_driver.total_earnings).must_equal 6054.44
      end

    end

    describe "can go online" do
      # Your code here

    end

    describe "can go offline" do
      # Your code here
    end

    # You may have additional methods to test
  end
end
