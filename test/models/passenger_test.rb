require "test_helper"

describe Passenger do
  let (:new_passenger) {
    Passenger.new(name: "Kari", phone_num: "111-111-1211")
  }
  it "can be instantiated" do
    expect(new_passenger.valid?).must_equal true
  end

  it "will have the required fields" do
    new_passenger.save
    passenger = Passenger.first
    [:name, :phone_num].each do |field|

      expect(passenger).must_respond_to field
    end
  end

  describe "relationships" do
    it "can have many trips" do
      new_passenger.save
      new_driver = Driver.create(name: "Waldo", vin: "ALWSS52P9NEYLVDE9")
      trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1234)
      trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)

      expect(new_passenger.trips.count).must_equal 2
      new_passenger.trips.each do |trip|
        expect(trip).must_be_instance_of Trip
      end
    end
  end

  describe "validations" do
    it "must have a name" do
      new_passenger.name = nil

      expect(new_passenger.valid?).must_equal false
      expect(new_passenger.errors.messages).must_include :name
      expect(new_passenger.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "must have a phone number" do
      new_passenger.phone_num = nil

      expect(new_passenger.valid?).must_equal false
      expect(new_passenger.errors.messages).must_include :phone_num
      expect(new_passenger.errors.messages[:phone_num]).must_equal ["can't be blank"]
    end
  end

  describe "custom methods" do
    
    before do 
      @new_driver = Driver.create(name: "Ron Weasley", vin: "5938282E")
      @no_trips_passenger = Passenger.new(name: "Bob", phone_num: "111-111-1211")
      @kari_passenger = Passenger.new(name: "Kari", phone_num: "123-456-7890")
      @no_trips_passenger.save
      @kari_passenger.save
    end

    describe "get_total_expenses" do
      it "returns 0 if passenger has not had any trips" do
        expect(@no_trips_passenger.get_total_expenses).must_equal 0
      end

      it 'returns the correct total expenses for a passenger\'s trips' do
        trip_1 = Trip.create(driver_id: @new_driver.id, passenger_id: @kari_passenger.id, date: Date.today, rating: 5, cost: 5)
        trip_2 = Trip.create(driver_id: @new_driver.id, passenger_id: @kari_passenger.id, date: Date.today, rating: 3, cost: 20)

        expect(@kari_passenger.get_total_expenses).must_equal 25
      end
    end
  end
end
