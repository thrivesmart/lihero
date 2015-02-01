json.array!(@memberships) do |membership|
  json.extract! membership, :id, :organization_id, :user_id, :privileges, :creator_id
  json.url membership_url(membership, format: :json)
end
