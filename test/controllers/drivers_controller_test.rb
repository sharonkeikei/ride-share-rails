require "test_helper"

describe DriversController do
  # Note: If any of these tests have names that conflict with either the requirements or your team's decisions, feel empowered to change the test names. For example, if a given test name says "responds with 404" but your team's decision is to respond with redirect, please change the test name.

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
      # Ensure that there are zero drivers saved
      # Assert
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
      
      # Becca said don't worry about testing render
      # TO DO: figure out which redirect test will work
      # must_redirect_to new_driver_path
      # must_respond_with :success
      # assert_template :new
    end
  end
  
  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid driver" do
      # Arrange
      # Ensure there is an existing driver saved
      driver = Driver.create(name: 'Hello Kitty', vin: 'abc12345')
      # Act  
      get edit_driver_path(driver.id)
      # Assert
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing driver" do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      invalid_driver_id = -1
      # Act
      get edit_driver_path(invalid_driver_id)
      # Assert
      must_redirect_to drivers_path
    end
  end

  describe "update" do
    it "can update an existing driver with valid information accurately, and redirect" do
      # Arrange
      # Ensure there is an existing driver saved
      # Assign the existing driver's id to a local variable
      # Set up the form data
      driver = Driver.create(name: 'Hello Kitty', vin: 'abc12345')
      update_params = {
        driver: {
          name: 'Harry Potter',
          vin: '123456789'
        }
      }
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect{patch driver_path(driver.id), params: update_params}.wont_change 'Driver.count'
      # Assert
      # Use the local variable of an existing driver's id to find the driver again, and check that its attributes are updated
      # Check that the controller redirected the user
      # put request
      must_redirect_to driver_path(driver.id)
      driver.reload
      expect(driver.name).must_equal update_params[:driver][:name]
      expect(driver.vin).must_equal update_params[:driver][:vin]
    end

    it "does not update any driver if given an invalid id, and responds with a 404" do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      # Set up the form data
      invalid_update_id = 99999999999999999999999999999999999999999999999999999
      
      update_params = {
        driver: {
          name: 'Harry Potter',
          vin: '123456789'
        }
      }
      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect{patch driver_path(invalid_update_id), params: update_params}.wont_change 'Driver.count'
      # Assert
      # Check that the controller gave back a 404
      must_respond_with 404
    end

    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Ensure there is an existing driver saved
      # Assign the existing driver's id to a local variable
      # Set up the form data so that it violates Driver validations

      # Act-Assert
      # Ensure that there is no change in Driver.count

      # Assert
      # Check that the controller redirects

    end
  end

  describe "destroy" do
    it "destroys the driver instance in db when driver exists, then redirects" do
      # Arrange
      # Ensure there is an existing driver saved

      # Act-Assert
      # Ensure that there is a change of -1 in Driver.count

      # Assert
      # Check that the controller redirects

    end

    it "does not change the db when the driver does not exist, then responds with " do
      # Arrange
      # Ensure there is an invalid id that points to no driver

      # Act-Assert
      # Ensure that there is no change in Driver.count

      # Assert
      # Check that the controller responds or redirects with whatever your group decides

    end
  end

  describe "toggle_available" do
    before do
      Driver.create(name: 'Hello Kitty', vin: '12345678', available: true)
    end

    it "updates the available boolean from true to false when clicked" do
      # test that patch happens

      driver = Driver.first

      patch toggle_available_path(driver.id)
      driver.reload

      must_redirect_to driver_path(driver.id)
      expect(driver.available).must_equal false
    end


    it "updates the available boolean from false to true when clicked" do
      driver = Driver.first

      patch toggle_available_path(driver.id)
      patch toggle_available_path(driver.id)
      driver.reload

      must_redirect_to driver_path(driver.id)
      expect(driver.available).must_equal true
    end

  end
end
