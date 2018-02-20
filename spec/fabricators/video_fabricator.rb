Fabricator(:video) do
	title { Faker::Name.name }
	description { Faker::Lorem.paragraph }
end