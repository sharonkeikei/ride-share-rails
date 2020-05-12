class Passenger < ApplicationRecord
  has_many :trips , dependent: :destroy
  validates :name, :phone_num, presence: true


  def get_total_expenses
    return 0 if self.trips.length == 0

    expenses_list = []
    self.trips.each do |trip|
      expenses_list << trip.cost
    end

    return expenses_list.sum.round(2)
  end
end
