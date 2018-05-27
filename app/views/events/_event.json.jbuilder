json.extract! event, :id, :title, :description, :start_time, :end_time, :created_at, :updated_at, :topology_id
json.url event_url(event, format: :json)
