require "test_helper"

class ReservationAuthorizationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @alice = User.create!(email: "alice@example.com", password: "password123")
    @bob = User.create!(email: "bob@example.com", password: "password123")
    @court = create_court
    @reservation = build_reservation(court: @court, user: @alice, customer_name: "Cliente Alice")
    @reservation.save!
  end

  test "anonymous visitors are redirected to the sign-in page" do
    get reservation_path(@reservation)
    assert_redirected_to new_user_session_path
  end

  test "the owner can see their reservation" do
    sign_in @alice
    get reservation_path(@reservation)
    assert_response :success
  end

  test "another user cannot see someone else's reservation" do
    sign_in @bob
    get reservation_path(@reservation)
    assert_response :not_found
  end

  test "another user cannot cancel someone else's reservation" do
    sign_in @bob
    delete reservation_path(@reservation)

    assert_response :not_found
    assert_equal "confirmee", @reservation.reload.status
  end

  test "the owner can cancel their reservation" do
    sign_in @alice
    delete reservation_path(@reservation)

    assert_redirected_to reservations_path
    assert_equal "annulee", @reservation.reload.status
  end

  test "the index only lists the current user's reservations" do
    sign_in @bob
    get reservations_path

    assert_response :success
    assert_no_match "Cliente Alice", response.body
  end

  test "a created reservation belongs to the signed-in user" do
    sign_in @bob

    assert_difference "Reservation.count", 1 do
      post reservations_path, params: { reservation: {
        court_id: @court.id,
        reservation_date: Date.today + 3,
        start_time: "10:00",
        end_time: "11:30",
        customer_name: "Bob",
        customer_email: "bob@example.com",
        customer_phone: "0600000000"
      } }
    end

    assert_equal @bob, Reservation.order(:id).last.user
  end
end
