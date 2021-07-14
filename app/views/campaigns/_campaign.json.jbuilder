json.extract! campaign, :id, :name, :description, :status, :user_id, :created_at, :updated_at
json.url campaign_url(campaign, format: :json)
