json.array!(@lists) do |list|
  json.extract! list, :id, :organization_id, :name, :permalink, :description, :picurl, :creator_id
  json.url list_url(list, format: :json)
end
