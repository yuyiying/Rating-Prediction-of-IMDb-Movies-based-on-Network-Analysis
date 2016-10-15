import re
if __name__ == '__main__':
	
	outfile1 = open ("/Users/stephanieyu/Desktop/232/final/merge_file.txt",'w')
	readfile1 = open("/Users/stephanieyu/Desktop/232/final/project_2_data/actor_movies.txt",'r')
	readfile2 = open("/Users/stephanieyu/Desktop/232/final/project_2_data/actress_movies.txt",'r')
    threshold = 5  #remove the actor/actress with less than 5 movies
	count = 0
	for line in readfile1.readlines():
		line = line[:-1]
		tmp=line.split("\t\t")
		if len(tmp)< threshold+1:
			continue
		outfile1.write(str(count))
		count +=1
		for i in tmp[1:]:
			m = i.find(")")
			i = i[:m+1]
			i.strip(" ")
			i.strip("\t")
			outfile1.write("\t\t")
			outfile1.write(str(i))
		outfile1.write("\n")
	
	print "Finish actor"
	for line in readfile2.readlines():
		line = line[:-1]
		tmp=line.split("\t\t")
		if len(tmp)<threshold+1:
			continue
		outfile1.write(str(count))
		count +=1
		for i in tmp[1:]:
			m = i.find(")")
			i = i[:m+1]
			i.strip(" ")
			i.strip("\t")
			outfile1.write("\t\t")
			outfile1.write(str(i))
		outfile1.write("\n")
	outfile1.close()
	print "Finish actress"

