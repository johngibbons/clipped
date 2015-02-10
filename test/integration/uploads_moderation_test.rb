require 'test_helper'

class UploadsModerationTest < ActionDispatch::IntegrationTest
  
  def setup
    @unapproved = uploads(:orange)
    @approved   = uploads(:walking_man)
    @admin      = users(:michael)
    @nonadmin   = users(:archer)
  end

  
end
