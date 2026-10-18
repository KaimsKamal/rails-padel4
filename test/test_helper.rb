ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)

    def create_court(attrs = {})
      Court.create!({ name: "Court 1", court_type: "interieur", status: "disponible" }.merge(attrs))
    end

    def build_reservation(court:, **attrs)
      Reservation.new({
        court: court,
        reservation_date: Date.today + 1,
        start_time: "18:00",
        end_time: "19:30",
        customer_name: "Jean Dupont",
        customer_email: "jean@example.com",
        customer_phone: "0600000000",
        status: "confirmee"
      }.merge(attrs))
    end
  end
end
