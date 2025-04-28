json.extract! movement, :id, :armeiro_id, :guard_id, :weapon_id, :movement_type, :date, :time, :ammo_count, :ammo_caliber, :magazine_count, :justification, :created_at, :updated_at
json.url movement_url(movement, format: :json)
