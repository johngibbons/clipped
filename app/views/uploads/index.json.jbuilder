json.array!(@uploads) do |upload|
  json.extract! upload, :id, :image, :tags
  json.url upload_url(upload, format: :json)
end
