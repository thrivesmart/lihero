json.array!(@organizations) do |organization|
  json.extract! organization, :id, :name, :permalink, :website, :creator_id
  json.url organization_url(organization, format: :json)
end
