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

  def id
    ""
  end

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

  def favorite(upload)
    favoriter_relationships.none
  end

  def unfavorite(upload)
    favoriter_relationships.none
  end

  def favoriting?(upload)
    false
  end

  def comments
    Comment.none
  end

  def comment_on(upload:, body:)
    comments.none
  end

  def commenting_on?(upload)
    false
  end

  def upload_owner?(upload)
    false
  end

  def password_reset_expired?
    true
  end

  def password_digest
    ""
  end

  def remember_token
    ""
  end

end
