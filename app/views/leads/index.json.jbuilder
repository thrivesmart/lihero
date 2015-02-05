json.array!(@leads) do |lead|
  json.extract! lead, :id, :list_id, :creator_id, :linkedinid, :kind, :archived_at, :name, :email, :phone, :picurl, :details, :notes, :history
  json.url lead_url(lead, format: :json)
end
