action = Category.create(name: 'Action')
comedy = Category.create(name: 'Comedy')

Video.create([
	{title: 'Monk', description: 'Monk is a funny guy and... actually I never watched the show so I cannot tell you too much more about it. If you want to make a couple bucks, re-write this description when you are done streaming. okthxbai', category: action},
	{title: 'Futurama', description: 'Fry is a funny guy and... actually I have only seen a few episodes of the show so I cannot tell you too much more about it. If you want to make a couple bucks, re-write this description when you are done streaming. okthxbai', category: comedy},
	# {title: 'SNL', description: 'saturday night live. You know it. You love it.', category: comedy},
	# {title: 'kids in the hall', description: 'Canadian sketch comedy.', category: comedy},
	{title: 'Key and Peele', description: 'Fresh sketch comedy show. Too funny for words.', category: comedy},
	# {title: 'thedailyshow', description: 'This is the one with with Jon Stewart.', category: comedy},
	{title: 'Late Night', description: 'This is the one with Seth Meyers. What a funny guy.', category: comedy},
	# {title: 'Die Hard', description: 'Bruce! Bruce Willis is THE man.', category: action}
])
# Video.first.update_columns(small_cover: 'monk.jpg', large_cover: 'monk_large.jpg')
Video.first.update_columns(small_cover: 'futurama.jpg', large_cover: 'futurama_large.jpg')
# Video.third.update_columns(small_cover: 'snl.jpg', large_cover: 'snl.jpg')
# Video.third.update_columns(small_cover: 'kidsinthehall.jpg', large_cover: 'kidsinthehall_large.jpg')
Video.second.update_columns(small_cover: 'keyandpeele.jpg', large_cover: 'keyandpeele_large.jpg')
# Video.fifth.update_columns(small_cover: 'thedailyshow.jpg', large_cover: 'thedailyshow_large.jpg')
Video.third.update_columns(small_cover: 'latenight.jpg', large_cover: 'latenight_large.jpg')
Video.fourth.update_columns(small_cover: 'diehard.jpg', large_cover: 'diehard.jpg')
bill = User.create(full_name: 'Bill Braskey', email: 'bill@hotmail.com', password: 'password', admin: true)
bob = User.create(full_name: 'Bob Braskey', email: 'bob@hotmail.com', password: 'password', admin: false)
die_hard = Video.find_by(title: 'Die Hard')
review1 = Review.create(content: 'Bruce is really at the top of his game. Wow. This is the most action I have seen in a movie with Russians. It\'s m\'vaveorite movie.', rating: 4, user: bill, video: die_hard)
review2 = Review.create(content: 'I changed my mind. I don\'t like it', rating: 1, user: bill, video: die_hard)
