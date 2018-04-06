Fabricator(:video) do
	title { Faker::Name.name }
	description { Faker::Lorem.paragraph(1) }
	small_cover "snl.jpg"
end