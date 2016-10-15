if __name__ == '__main__':
	outfile = open ("/Users/zhimingzhuang/Documents/EE232E/proj2/top_100_director.txt",'w', )
	read_top_100 = open("/Users/zhimingzhuang/Documents/EE232E/proj2/top_100_movie.txt",'r')
	read_director = open ("/Users/zhimingzhuang/Documents/EE232E/proj2/director_movies.txt",'r')
	
	movie_director = dict()
	for line in read_director.readlines():
		line = line[:-1]
		tmp = line.split("\t\t")
		for item in tmp[1:]:
			m = item.find(")")
			item = item[:m+1]
			item.strip(" ")
			item.strip("\t")
			movie_director[item] = tmp[0]
	read_director.close()

	directors_100 = set()
	for line in read_top_100.readlines():
		line = line[:-1]
		if movie_director.has_key(line):
			if(len(directors_100) >= 100):
				break
			directors_100.add(str(movie_director[line]))
			#outfile.write(str(movie_director[line]) + "\n" )
	read_top_100.close()

	for d in directors_100:
		outfile.write(d + "\n" )

	outfile.close()