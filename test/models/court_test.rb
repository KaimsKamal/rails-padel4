require "test_helper"

class CourtTest < ActiveSupport::TestCase
  test "is valid with correct attributes" do
    assert create_court.persisted?
  end

  test "requires a name" do
    court = Court.new(court_type: "interieur", status: "disponible")
    assert_not court.valid?
    assert court.errors[:name].any?
  end

  test "rejects an unknown court type" do
    court = Court.new(name: "Court 2", court_type: "piscine", status: "disponible")
    assert_not court.valid?
  end

  test "rejects an unknown status" do
    court = Court.new(name: "Court 2", court_type: "couvert", status: "ferme")
    assert_not court.valid?
  end

  test "available scope excludes courts under maintenance" do
    open_court = create_court(name: "Ouvert")
    closed_court = create_court(name: "Ferme", status: "maintenance")

    assert_includes Court.available, open_court
    assert_not_includes Court.available, closed_court
  end
end
