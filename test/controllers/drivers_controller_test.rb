require "test_helper"

describe DriversController do

  describe "index" do
    it "responds with success when there are many drivers saved" do

      driver1 = Driver.new(name: "Harry Potter", vin: "12345")
      driver1.save
      driver2 = Driver.new(name: "Hermione Granger", vin: "848372")
      driver2.save

      get drivers_path
      must_respond_with :success
    
      expect(Driver.all.length).must_equal 2
    end


    it "responds with success when there are no drivers saved" do
      expect(Driver.all.length).must_equal 0

      get drivers_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid driver" do
      driver1 = Driver.new(name: "Harry Potter", vin: "12345")
      driver1.save

      expect(driver1.valid?).must_equal true
      expect(driver1.errors.messages).must_be_empty

      get driver_path(driver1.id)
      must_respond_with :success
    end

    it "redirects to #index if invalid driver id" do
      invalid_id = -1
      get driver_path(invalid_id)
      must_redirect_to drivers_path
    end
  end

  describe "new" do
    it "responds with success" do
      get new_driver_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new driver with valid information accurately, and redirect" do
      driver_param = {
        driver: {
          name: "Harry Potter",
          vin: "12345"
        }
      }

      expect{post drivers_path, params: driver_param}.must_differ "Driver.count", 1
      must_redirect_to driver_path(Driver.last)
      expect(Driver.last.name).must_equal driver_param[:driver][:name]
      expect(Driver.last.vin).must_equal driver_param[:driver][:vin]
    end

    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      # Set up the form data so that it violates Driver validations
      driver_param = {
        driver: {
          vin: "12345"
        }
      }

      expect{post drivers_path, params: driver_param}.must_differ "Driver.count", 0
    end
  end
  
  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid driver" do
      # Ensure there is an existing driver saved
      driver = Driver.create(name: 'Hello Kitty', vin: 'abc12345')

      get edit_driver_path(driver.id)

      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing driver" do
      # Ensure there is an invalid id that points to no driver
      invalid_driver_id = -1

      get edit_driver_path(invalid_driver_id)

      must_redirect_to drivers_path
    end
  end

  describe "update" do
    it "can update an existing driver with valid information accurately, and redirect" do
      driver = Driver.create(name: 'Hello Kitty', vin: 'abc12345')
      update_params = {
        driver: {
          name: 'Harry Potter',
          vin: '123456789'
        }
      }
  
      expect{patch driver_path(driver.id), params: update_params}.wont_change 'Driver.count'
      must_redirect_to driver_path(driver.id)
      driver.reload
      expect(driver.name).must_equal update_params[:driver][:name]
      expect(driver.vin).must_equal update_params[:driver][:vin]
    end

    it "does not update any driver if given an invalid id, and responds with a 404" do
      invalid_update_id = -1
      
      update_params = {
        driver: {
          name: 'Harry Potter',
          vin: '123456789'
        }
      }

      expect{patch driver_path(invalid_update_id), params: update_params}.wont_change 'Driver.count'
      must_respond_with 404
    end

    it "does not update a driver if the form data violates Driver validations, and responds with a redirect" do
      dobby_the_driver = Driver.create(name: 'Dobby', vin: '12345789')

      driver_param = {
        driver: {
          vin: nil
        }
      }

      expect{patch driver_path(dobby_the_driver.id), params: driver_param}.wont_change "Driver.count"
      dobby_the_driver.reload
      expect(dobby_the_driver.name).must_equal 'Dobby'
      expect(dobby_the_driver.vin).must_equal '12345789'
      # we render :edit so we decide not to test render
    end
  end

  describe "destroy" do
    it "destroys the driver instance in db when driver exists, then redirects" do
      removing_driver = Driver.create(name: 'Winnie the pooh', vin: 'FACC4578STQ')
      expect{delete driver_path(removing_driver.id)}.must_differ 'Driver.count', -1
      must_redirect_to drivers_path
    end

    it "does not change the db when the driver does not exist, then redirect back to drivers list" do
      non_existing_id = -1
      expect{delete driver_path(non_existing_id)}.wont_change 'Driver.count'
      must_redirect_to drivers_path
    end
  end

  describe "toggle_available" do
    before do
      Driver.create(name: 'Hello Kitty', vin: '12345678', available: true)
    end

    it "updates the available boolean from true to false" do
      driver = Driver.first

      patch toggle_available_path(driver.id)
      driver.reload

      must_redirect_to driver_path(driver.id)
      expect(driver.available).must_equal false
    end


    it "updates the available boolean from false to true" do
      driver = Driver.first

      patch toggle_available_path(driver.id)
      patch toggle_available_path(driver.id)
      driver.reload
      
      must_redirect_to driver_path(driver.id)
      expect(driver.available).must_equal true
    end
  end
end
