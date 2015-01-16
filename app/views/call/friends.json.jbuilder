json.friends do
  json.array!(@friends) do |friend|
    json.extract! friend, :id, :rtcc_uid, :rtcc_profile, :rtcc_domain
  end
end
