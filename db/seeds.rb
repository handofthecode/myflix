action = Category.create(name: 'Action')
comedy = Category.create(name: 'Comedy')

# Video.create([
# 	{title: 'Monk', description: 'Monk is a funny guy and... actually I never watched the show so I cannot tell you too much more about it. If you want to make a couple bucks, re-write this description when you are done streaming. okthxbai',
# 	 small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category: comedy},
# 	{title: 'Futurama',
# 	 description: 'Fry is a funny guy and... actually I never watched the show so I cannot tell you too much more about it. If you want to make a couple bucks, re-write this description when you are done streaming. okthxbai',
# 	small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/futurama_large.jpg', category: comedy},
# 	{title: 'SNL',
# 	description: 'saturday night live', category: comedy,
# 	small_cover_url: '/tmp/snl.jpg', large_cover_url: '/tmp/snl.jpg'},
# 	{title: 'kids in the hall',
# 	description: 'canadian comedy', category: comedy,
# 	small_cover_url: '/tmp/kidsinthehall.jpg', large_cover_url: '/tmp/kidsinthehall_large.jpg'},
# 	{title: 'Key and Peele',
# 	description: 'sketch comedy', category: comedy,
# 	small_cover_url: '/tmp/keyandpeele.jpg', large_cover_url: '/tmp/keyandpeele_large.jpg'},
# 	{title: 'thedailyshow',
# 	description: 'with jon', category: comedy,
# 	small_cover_url: '/tmp/thedailyshow.jpg', large_cover_url: '/tmp/thedailyshow_large.jpg'},
# 	{title: 'Late Night',
# 	description: 'the one with seth meyers', category: comedy,
# 	small_cover_url: '/tmp/latenight.jpg', large_cover_url: '/tmp/latenight_large.jpg'},
# 	{title: 'Die Hard',
# 	description: 'Bruce!', category: action,
# 	small_cover_url: '/tmp/diehard.jpg', large_cover_url: '/tmp/diehard.jpg'}
# ])
bill = User.create(full_name: 'Bill Braskey', email: 'bill@hotmail.com', password: 'password', admin: true)
# die_hard = Video.find_by(title: 'Die Hard')
# review1 = Review.create(content: 'Bruce is really at the top of his game. Wow. This is the most action I have seen in a movie with Russians. It\'s m\'vaveorite movie.', rating: 4, user: bill, video: die_hard)
# review2 = Review.create(content: 'I changed my mind. I don\'t like it', rating: 1, user: bill, video: die_hard)
