require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires a valid email and a password" do
    assert_not User.new(email: "invalide", password: "password123").valid?
    assert_not User.new(email: "a@example.com", password: "").valid?
  end

  test "rejects a duplicate email" do
    User.create!(email: "a@example.com", password: "password123")
    assert_not User.new(email: "a@example.com", password: "password123").valid?
  end

  test "display_name falls back to the email prefix" do
    user = User.new(email: "kaims@example.com")
    assert_equal "kaims", user.display_name
  end

  test "avatar falls back to a default emoji" do
    assert_equal "👤", User.new(email: "a@example.com").avatar_or_default
  end
end
