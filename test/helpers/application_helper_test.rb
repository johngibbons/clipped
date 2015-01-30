require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "Clipped"
    assert_equal full_title("Help"), "Help | Clipped"
  end
end