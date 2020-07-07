json.extract! profile, :id, :gender, :about_me, :interest, :user_id, :created_at, :updated_at
json.url profile_url(profile, format: :json)
