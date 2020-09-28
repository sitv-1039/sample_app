module UsersHelper
  def gravatar_for user
    md5 = Digest::MD5.new
    gravatar_id = md5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
