json.array!(@students) do |student|
  json.extract! student, :id, :first_name, :last_name, :date_of_birth, :family_id, :rating, :active
  json.url student_url(student, format: :json)
end