library("igraph")
library("netrw")
library("hash")
#Q4
g<-read.graph("/Users/zhimingzhuang/Documents/EE232E/proj2/movie_edge_list.txt",format="ncol",directed=FALSE)
com <- fastgreedy.community(g, weights = E(g)$weight)

#genreate id_genre
File_gene<-file("/Users/zhimingzhuang/Documents/EE232E/proj2/id_genre.txt",open="r")
g_line<-readLines(File_gene,1,encoding="latin1")
nodeId<-0
Genre<-rep("",vcount(g))
while(length(g_line)!=0)
{
  gline=strsplit(g_line,"\t\t")
  nodeId<-(1:vcount(g))[V(g)$name==gline[[1]][1]]
  Genre[nodeId]<-gline[[1]][2]
  g_line<-readLines(File_gene,1,encoding="latin1")
} 
close(File_gene)

#genreate id_rating
File_rate<-file("/Users/zhimingzhuang/Documents/EE232E/proj2/id_rating.txt",open="r")
r_line<-readLines(File_rate,1,encoding="latin1")
nodeId<-0
Rate<-rep("0",vcount(g))
while(length(r_line)!=0)
{
  rline=strsplit(r_line,"\t\t")
  nodeId<-(1:vcount(g))[V(g)$name==rline[[1]][1]]
  Rate[nodeId]<-rline[[1]][2]
  r_line<-readLines(File_rate,1,encoding="latin1")
} 
close(File_rate)

#Q5
V(g)$Genre<-Genre
V(g)$Rate<-Rate

sizes(com)
com_size<-0
gene_i<-list()
for(i in 1:length(sizes(com)))
{ 
  com_size<-sizes(com)[i]
  movie_i<-(1:vcount(g))[com$membership == i]
  movie_i_gene<-V(g)[movie_i]$Genre
  movie_i_gene<-table(movie_i_gene)
  gene_i[[i]]<-names(movie_i_gene[which(movie_i_gene>=(0.2*com_size))])
}









l