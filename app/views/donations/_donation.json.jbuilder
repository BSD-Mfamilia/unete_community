json.extract! donation, :id, :amount, :invited_by, :cycle, :campaign_id, :user_id, :created_at, :updated_at
json.url donation_url(donation, format: :json)
