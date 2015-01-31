json.array!(@org_user_privileges) do |org_user_privilege|
  json.extract! org_user_privilege, :id, :organization_id, :user_id, :privileges, :creator_id
  json.url org_user_privilege_url(org_user_privilege, format: :json)
end
