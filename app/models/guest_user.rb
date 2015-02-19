class GuestUser
  include ActiveModel::Model

  def activated
    false
  end
  alias_method :activated?, :activated

  def admin
    false
  end
  alias_method :admin?, :admin

  def tags
    ""
  end

  def email
    ""
  end

  def name
    "Guest"
  end

  def uploads
    Upload.none
  end

  def remember
    false
  end

  def authenticated?(attribute, token)
    false
  end

  def forget
    false
  end

  def like(upload)
    false
  end

  def unlike(upload)
    false
  end

  def liking?(upload)
    false
  end

end