##############################problem 8##############################
library("igraph")
library("netrw")
library("hash")

g<-read.graph("/Users/zhimingzhuang/Documents/EE232E/proj2/movie_edge_list.txt",format="ncol",directed=FALSE)

movieid_to_nodeNum <- list()
for(i in 1:length(V(g)$name)){
  print(i)
  movieid_to_nodeNum[V(g)$name[i]] = i
}

#genreate id_rating
File_rate<-file("/Users/zhimingzhuang/Documents/EE232E/proj2/id_rating.txt",open="r")
r_line<-readLines(File_rate,1,encoding="latin1")
nodeId<-0
Rate<-list()
Rate<-rep("0",vcount(g))
i <- 1
while(length(r_line)!=0)
{
  print(i)
  i <- i + 1
  rline=strsplit(r_line,"\t\t")
  nodeId <- movieid_to_nodeNum[rline[[1]][1]][[1]]
  Rate[nodeId]<-rline[[1]][2]
  r_line<-readLines(File_rate,1,encoding="latin1")
} 
close(File_rate)

V(g)$Rate<-Rate
# movie_interest<-c("Batman v Superman: Dawn of Justice (2016)",
#                   "Mission: Impossible - Rogue Nation (2015)",
#                   "Minions (2015)")

movie_interest<-c("10754",
                  "58077",
                  "87590")

g_actor<-read.graph("/Users/zhimingzhuang/Documents/EE232E/proj2/edge_list.txt",format="ncol",directed=TRUE)

p_rScore<-page.rank (g_actor, algo = c("prpack", "arpack", "power"),
                     directed = TRUE, damping = 0.85,
                     weights = NULL) 
p_rScore1<-sort(p_rScore$vector,decreasing=TRUE)

File_name<-file("/Users/zhimingzhuang/Documents/EE232E/proj2/movie_list.txt",open="r")
n_line<-readLines(File_name, 1, encoding = "latin1")
nodeId<-0
a_rank<-list()
# actorList<-list()
i <- 1;

while(length(n_line)!=0) {
  print(i)
  i <- i + 1
  nline = strsplit(n_line,"\t\t")
  
  nodeId <- movieid_to_nodeNum[nline[[1]][2]][[1]]
  if(length(nodeId) != 0) {
    actors <- nline[[1]][3:length(nline[[1]])]
    actorRank_tmp <- c() 
    for(j in 1:length(actors)) { 
      r <- p_rScore1[which(names(p_rScore1) == actors[j])]
      actorRank_tmp <- append(actorRank_tmp, r)  
    }
    actorRank_tmp <- sort(actorRank_tmp, decreasing = TRUE)
    a_rank[[nodeId]] <- actorRank_tmp[1:5] 
  }
    
  n_line <- readLines(File_name,1, encoding = "latin1")
}
close(File_name)


File_top<-file("/Users/zhimingzhuang/Documents/EE232E/proj2/top_100_director.txt",open="r")
File_director<-file("/Users/zhimingzhuang/Documents/EE232E/proj2/movieid_director.txt",open="r")
top<-readLines(File_top,encoding="latin1")
d_line<-readLines(File_director,1,encoding="latin1")
nodeId<-0
Director<-rep("",vcount(g))
i <- 1
while(length(d_line)!=0) {
  print(i)
  i <- i + 1
  dline=strsplit(d_line,"\t\t")
  
  nodeId<-movieid_to_nodeNum[dline[[1]][1]][[1]]
  if(length(nodeId) != 0) {
    Director[nodeId]<-dline[[1]][2]
  }
  d_line<-readLines(File_director,1,encoding="latin1")
}
V(g)$Director<-Director
close(File_director)
close(File_top)


topDirector<-unique(top)[1:100]

boDirect<-list()
for(i in 1:vcount(g))
{
  print(i)
  tmpDirect<-rep(0,106)
  if(V(g)[i]$Director %in% topDirector)
  {
    tmpDirect[101]<-1
    j<-which(topDirector==V(g)[i]$Director)
    tmpDirect[j]<-1
  }
  tmpDirect[102:106] <- a_rank[[ i ]][1:5]
  boDirect[[i]]<-tmpDirect
}
lapply(boDirect, write, "features.txt", append=TRUE, ncolumns=106)

lapply(Rate, write, "labels.txt", append=TRUE, ncolumns=1)

tests <- list()
for(i in 1:3) {
  print(i)
  tmptest<-rep(0,106)
  nodeId <- movieid_to_nodeNum[movie_interest[i]][[1]]
  tmptest[1:101] = boDirect[[nodeId]][1:101]
  tmptest[102:106] = boDirect[[nodeId]][102:106] 
  tests[[i]]<-tmptest
}
lapply(tests, write, "tests.csv", append=TRUE, ncolumns=106)

