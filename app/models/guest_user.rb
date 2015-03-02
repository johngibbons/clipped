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

  def password
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

  def authenticate(password)
    false
  end

  def forget
    false
  end

  def like(upload)
    liker_relationships.none
  end

  def unlike(upload)
    liker_relationships.none
  end

  def liking?(upload)
    false
  end

  def upload_owner?(upload)
    false
  end

end