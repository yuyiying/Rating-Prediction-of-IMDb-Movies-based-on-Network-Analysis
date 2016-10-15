library("igraph")
library("netrw")
library("hash")
#movie_interest<-c("Batman v Superman: Dawn of Justice (2016)",
#                  "Mission: Impossible - Rogue Nation (2015)",
#                  "Minions (2015)")
movie_interest<-c("10753",
                  "58077",
                  "87590")
#V(g)$movieName<-name

nei<-list()
comId<-rep(0,3)
for(i in 1:3)
{ 
  nodeID<-(1:vcount(g))[V(g)$name==movie_interest[i]]
  tmp<-neighborhood(g,1,V(g)[nodeID])
  nei[[i]]<-tmp[[1]][2:length(tmp[[1]])]
  print(movie_interest[i])
  edge_weight <- rep(0,length(nei[[i]]))
  for(j in 1:length(nei[[i]]))
  {
    edge_weight[j] <- g[from=nodeID,to=nei[[i]][j]]
  }
  names(edge_weight)<-nei[[i]]
  edge_weight <- sort(edge_weight,decreasing=TRUE)
  nei_name<-as.numeric(names(edge_weight[1:5]))
  nei_name<-V(g)[nei_name]$name
  print(nei_name)
  comId[i]<-com$membership[nodeID]
  print(comId[i])
  print(gene_i[[comId[i]]])
}