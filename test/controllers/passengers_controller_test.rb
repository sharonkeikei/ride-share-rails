require "test_helper"

describe PassengersController do
  describe "index" do
    # Your tests go here
    it 'responds with success when there are multiple passenger created' do
      passenger1 = Passenger.new(name: "Harry Potter", phone_num: "12345678")
      passenger1.save
      passenger2 = Passenger.new(name: "Hermione Granger", phone_num: "848372154")
      passenger2.save

      get passengers_path
      must_respond_with :success
      expect(Passenger.all.length).must_equal 2

    end

    it 'will responds with success when there are no passenger saved' do
      expect(Passenger.all.length).must_equal 0

      get passengers_path
      must_respond_with :success
    end

  end

  describe "show" do
    it 'responds with success when showing an exisiting valid passenger' do
      passenger1 = Passenger.new(name: 'Harry Potter', phone_num: '123456')
      passenger1.save
      
      expect(passenger1.valid?).must_equal true
      expect(passenger1.errors.messages).must_be_empty
    end

    it'redirect to passenger #index page if invalid passenger id provided' do
      invalid_id = -115485454

      get passenger_path(invalid_id)
      must_redirect_to passengers_path
    end
  end

  describe "new" do
    it 'responds with success' do
      get new_passenger_path
      must_respond_with :success
    end
  end

  describe "create" do
    it 'can create a new passenger with valid information accurately and redirect after' do
      passenger_param = {
        passenger: {
          name: 'Sharon Cheung',
          phone_num: '123-456-789'
        }
      }
      
      expect{post passengers_path, params: passenger_param}.must_differ 'Passenger.count', 1
      must_redirect_to passenger_path(Passenger.last)

      expect(Passenger.last.name).must_equal passenger_param[:passenger][:name]
      expect(Passenger.last.phone_num).must_equal passenger_param[:passenger][:phone_num]
    end

    it 'does not create a passenger if the form data violates Passenger Validataion and respond with a redirect' do
      passenger_param = {
        passenger: {
          phone_num: nil,
        }
      }
      expect{post passengers_path, params: passenger_param}.wont_change 'Passenger.count'
    end
  end

  describe "edit" do
    # Your tests go here
    it 'responds with success when getting the edit page for an existing valid passenger' do
      testing_passenger = Passenger.create(name: 'Hello Kitty', phone_num: '12345678')

      get edit_passenger_path(testing_passenger.id)

      must_respond_with :success
    end

    it 'responds with redirect when trying to get an edit page for a non-exisiting passenger' do
      invalid_id = - 1

      get edit_passenger_path(invalid_id)

      must_redirect_to passengers_path
    end
  end

  describe "update" do
    it 'will update passenger profile accurately when a valid passenger is edited' do
      passenger = Passenger.create(name: 'Hello Kitty', phone_num: '12345678')
      update_params = {
        passenger: {
          name: 'Harry Potter',
          phone_num: '999999999'
        }
      }
      expect{patch passenger_path(passenger.id), params: update_params}.wont_change 'Passenger.count'
      passenger.reload
      must_redirect_to passenger_path(passenger.id)
      expect(passenger.name).must_equal update_params[:passenger][:name]
      expect(passenger.phone_num).must_equal update_params[:passenger][:phone_num]
    end

    it 'does not update any driver if given an invalid id and repsond with 404' do
      invalid_update_id = 99999999999999999999999999999999999999999999999999999
      update_params = {
        passenger: {
          name: 'Harry Potter',
          phone_num: '123456789'
        }
      }
      expect{patch passenger_path(invalid_update_id), params: update_params}.wont_change 'Passenger.count'
      must_respond_with 404
    end

    it 'does not update a driver if the form data violates Passenger validations, and responds with a render' do
      dobby_the_passenger = Passenger.create(name: 'Dobby', phone_num: '12345789')

      update_param = {
        passenger: {
          phone_num: nil
        }
      }
      expect{patch passenger_path(dobby_the_passenger.id), params: update_param}.wont_change 'Passenger.count'
      dobby_the_passenger.reload

      expect(dobby_the_passenger.name).must_equal 'Dobby'
      expect(dobby_the_passenger.phone_num).must_equal '12345789'
      # we render :edit so we decide not to test render
    end
  end

  describe "destroy" do
    # Your tests go here
    it "destroys the passenger instance in db when passenger exists, then redirects" do
      removing_passenger = Passenger.create(name: 'Winnie the pooh', phone_num: '12345678910')
      
      expect{delete passenger_path(removing_passenger.id)}.must_differ 'Passenger.count', -1
      must_redirect_to passengers_path
    end

    it "does not change the db when the passenger does not exist, then redirect back to passenger list" do
      non_existing_id = -1

      expect{delete passenger_path(non_existing_id)}.wont_change 'Passenger.count'
      must_redirect_to passengers_path
    end
  end
end
