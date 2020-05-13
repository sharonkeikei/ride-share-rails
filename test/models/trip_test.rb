require "test_helper"

describe Trip do
  before do
    @driver = Driver.new(name: "Billy", vin: "59593")
    @passenger = Passenger.new(name: "Betty", phone_num: "123955996932")

    @trip = Trip.new(date: Date.today, cost: 395.00, rating: 3)
    @trip.driver = @driver
    @trip.passenger = @passenger
  end

  it "can be instantiated" do
    expect(@trip.valid?).must_equal true
  end

  # Attempted but didn't finish/ get these to work before relevant lectures
  # _____________________________________________________________________

  # it "will have the required fields" do
  #   new_trip.save
  #   trip = Trip.first
  #   # will rating always be required/ will this break the code if rating not already assigned?
  #   [:date, :cost, :rating, :driver_id, :passenger_id].each do |field|
  #     expect(trip).must_respond_to field
  #   end
  # end

  # describe "relationships" do
  #   before do
  #     @new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
  #     @new_driver = Driver.create(name: "Bob", vin: "599258")
  #   end

  #   it "belongs to only one driver" do
  #     # NOT SURE driver and passenger are connected to trip here or if rails does it for us????
  #     new_trip.save

  #     # Assert
  #     # Any other assertions necessary???
  #     expect(new_trip.driver_id).must_equal new_driver.id
  #     # can we do the below?
  #     expect(new_trip.driver).must_be_instance_of Driver
  #   end

  #   it "belongs to only one passenger" do
  #     new_trip.save
  #     expect(new_trip.passenger_id).must_equal new_passenger.id
  #     expect(new_trip.Passenger).must_be_instance_of Passenger
  #   end
  # end

  # describe "validations" do
  #   it "must have a date" do
  #     new_trip.date = nil

  #     expect(new_trip.valid?).must_equal false
  #     expect(new_trip.errors.messages).must_include :date
  #     expect(new_trip.errors.messages[:date]).must_equal ["can't be blank"]
  #   end

  #   it "must have a cost" do
  #     new_trip.cost = nil

  #     expect(new_trip.valid?).must_equal false
  #     expect(new_trip.errors.messages).must_include :cost
  #     expect(new_trip.errors.messages[:cost]).must_equal ["can't be blank"]
  #   end

  #   it "must have a driver_id" do
  #     new_trip.driver_id = nil

  #     expect(new_trip.valid?).must_equal false
  #     expect(new_trip.errors.messages).must_include :driver_id
  #     expect(new_trip.errors.messages[:driver_id]).must_equal ["can't be blank"]
  #   end

  #   it "must have a passenger_id" do
  #     new_trip.passenger_id = nil

  #     expect(new_trip.valid?).must_equal false
  #     expect(new_trip.errors.messages).must_include :passenger_id
  #     expect(new_trip.errors.messages[:passenger_id]).must_equal ["can't be blank"]
  #   end
  # end

  # # Tests for methods you create should go here
  # describe "custom methods" do
  #   # Your tests here
  # end
end
