json.array!(@entourage_items) do |entourage_item|
  json.extract! entourage_item, :id, :image, :tags
  json.url entourage_item_url(entourage_item, format: :json)
end
