require "test_helper"

class PlayerTest < ActiveSupport::TestCase
  setup do
    @reservation = build_reservation(court: create_court)
    @reservation.save!
  end

  test "accepts a guest player with a name" do
    player = Player.new(reservation: @reservation, position: 1, name: "Invité")
    assert player.valid?
  end

  test "a guest player requires a name" do
    player = Player.new(reservation: @reservation, position: 1)
    assert_not player.valid?
    assert player.errors[:name].any?
  end

  test "a registered user does not need a name" do
    user = User.create!(email: "joueur@example.com", password: "password123")
    player = Player.new(reservation: @reservation, user: user, position: 2)
    assert player.valid?
  end

  test "rejects a position outside 1 to 4" do
    [ 0, 5 ].each do |position|
      player = Player.new(reservation: @reservation, position: position, name: "Invité")
      assert_not player.valid?, "la position #{position} devrait être refusée"
    end
  end

  test "rejects two players on the same position of a reservation" do
    Player.create!(reservation: @reservation, position: 1, name: "Premier")

    duplicate = Player.new(reservation: @reservation, position: 1, name: "Second")
    assert_not duplicate.valid?
    assert duplicate.errors[:position].any?
  end

  test "allows at most four players per reservation" do
    (1..4).each { |i| Player.create!(reservation: @reservation, position: i, name: "Joueur #{i}") }

    fifth = Player.new(reservation: @reservation, position: 5, name: "Joueur 5")
    assert_not fifth.valid?
    assert_equal 4, @reservation.players.count
  end

  test "initials are built from the guest name" do
    player = Player.new(name: "Marie Martin")
    assert_equal "MM", player.initials
  end
end
