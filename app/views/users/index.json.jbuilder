json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :email, :picurl, :googleid, :facebookid, :twitterid, :linkedinid, :githubid, :superuser
  json.url user_url(user, format: :json)
end
