module Capybara
  class Session
    def has_image?(src)
      has_xpath?("//img[contains(@src,\".*?/uploads/?.*?/#{src}/?.*?\")]")
    end
  end
end