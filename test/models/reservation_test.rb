require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  setup do
    @court = create_court
  end

  test "is valid with correct attributes" do
    assert build_reservation(court: @court).valid?
  end

  test "rejects an end time before the start time" do
    reservation = build_reservation(court: @court, start_time: "19:00", end_time: "18:00")
    assert_not reservation.valid?
    assert reservation.errors[:end_time].any?
  end

  test "rejects a reservation in the past" do
    reservation = build_reservation(court: @court, reservation_date: Date.today - 1)
    assert_not reservation.valid?
    assert reservation.errors[:reservation_date].any?
  end

  test "rejects an invalid email" do
    reservation = build_reservation(court: @court, customer_email: "pas-un-email")
    assert_not reservation.valid?
    assert reservation.errors[:customer_email].any?
  end

  test "rejects an unknown status" do
    reservation = build_reservation(court: @court, status: "inconnu")
    assert_not reservation.valid?
  end

  # --- Prévention des doublons -------------------------------------------

  test "rejects an overlapping reservation on the same court" do
    build_reservation(court: @court).save!

    overlapping = build_reservation(court: @court, start_time: "19:00", end_time: "20:30")
    assert_not overlapping.valid?
    assert_includes overlapping.errors[:base], "Ce créneau est déjà réservé"
  end

  test "rejects a reservation fully contained in an existing one" do
    build_reservation(court: @court, start_time: "18:00", end_time: "20:00").save!

    inside = build_reservation(court: @court, start_time: "18:30", end_time: "19:00")
    assert_not inside.valid?
  end

  test "rejects a reservation that fully contains an existing one" do
    build_reservation(court: @court, start_time: "18:30", end_time: "19:00").save!

    around = build_reservation(court: @court, start_time: "18:00", end_time: "20:00")
    assert_not around.valid?
  end

  test "accepts back-to-back reservations" do
    build_reservation(court: @court, start_time: "18:00", end_time: "19:30").save!

    next_slot = build_reservation(court: @court, start_time: "19:30", end_time: "21:00")
    assert next_slot.valid?
  end

  test "accepts the same slot on another court" do
    build_reservation(court: @court).save!
    other_court = create_court(name: "Court 2")

    assert build_reservation(court: other_court).valid?
  end

  test "accepts the same slot on another day" do
    build_reservation(court: @court).save!

    next_day = build_reservation(court: @court, reservation_date: Date.today + 2)
    assert next_day.valid?
  end

  test "a cancelled reservation frees its slot" do
    build_reservation(court: @court, status: "annulee").save!

    assert build_reservation(court: @court).valid?
  end

  # --- Annulation d'une réservation passée ------------------------------

  test "a past reservation can still be cancelled" do
    past = build_reservation(court: @court, reservation_date: Date.today - 1)
    past.save!(validate: false)

    assert past.update(status: "annulee")
  end
end
