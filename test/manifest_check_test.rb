require File.dirname(__FILE__) + "/helper"
require 'heroku/samorau'

class ManifestCheckTest < Test::Unit::TestCase
  include Heroku::Samorau

  def check ; ManifestCheck ; end

  setup do
    @data = Manifest.skeleton
  end

  test "is valid if no errors" do
    assert_valid
  end

  test "has a name" do
    @data.delete("name")
    assert_invalid
  end

  test "api key exists" do
    @data.delete("api")
    assert_invalid
  end

  test "api is a Hash" do
    @data["api"] = ""
    assert_invalid
  end

  test "api has a username" do
    @data["api"].delete("username")
    assert_invalid
  end

  test "api has a password" do
    @data["api"].delete("password")
    assert_invalid
  end

  test "api contains test" do
    @data["api"].delete("test")
    assert_invalid
  end

  test "api contains production" do
    @data["api"].delete("production")
    assert_invalid
  end

  test "api contains production of https" do
    @data["api"]["production"] = "http://foo.com"
    assert_invalid
  end

  test "api contains config_vars array" do
    @data["api"]["config_vars"] = "test"
    assert_invalid
  end

  test "api contains at least one config var" do
    @data["api"]["config_vars"].clear
    assert_invalid
  end

  test "plans key must exist" do
    @data.delete("plans")
    assert_invalid
  end

  test "plans key must be an Array" do
    @data["plans"] = ""
    assert_invalid
  end

  test "has at least one plan" do
    @data["plans"] = []
    assert_invalid
  end

  test "all plans are a hash" do
    @data["plans"][0] = ""
    assert_invalid
  end

  test "all plans have a name" do
    @data["plans"].first.delete("name")
    assert_invalid
  end

  test "all plans have a unique name" do
    @data["plans"] << @data["plans"].first.dup
    assert_invalid
  end

  test "plans have a price" do
    @data["plans"].first.delete("price")
    assert_invalid
  end

  test "plans have an integer price" do
    @data["plans"].first["price"] = "fiddy cent"
    assert_invalid
  end

  test "plans have a valid price_unit" do
    @data["plans"].first["price_unit"] = "first ov da munth"
    assert_invalid
  end

end