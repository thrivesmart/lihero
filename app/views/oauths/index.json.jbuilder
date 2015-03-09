json.array!(@oauths) do |oauth|
  json.extract! oauth, :id, :user_id, :account, :kind, :token, :secret
  json.url oauth_url(oauth, format: :json)
end
