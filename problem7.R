##############################problem 7##############################
library("igraph")

#########
#########
#########

g <- read.graph("/Users/zhimingzhuang/Documents/EE232E/proj2/movie_edge_list.txt",format="ncol", directed=FALSE)
com <- fastgreedy.community(g)

#genreate id_rating
File_rate <- file("/Users/zhimingzhuang/Documents/EE232E/proj2/id_rating.txt", open = "r")
r_line <- readLines(File_rate, 1, encoding = "latin1")
nodeId <- 0
Rate <- rep("0", vcount(g))
while(length(r_line) != 0) {
  rline = strsplit(r_line, "\t\t")
  nodeId <- (1 : vcount(g))[V(g)$name == rline[[1]][1]]
  Rate[nodeId] <- rline[[1]][2]
  r_line <- readLines(File_rate, 1, encoding = "latin1")
} 
close(File_rate)

V(g)$Rate <- Rate

# movie_interest<-c("Batman v Superman: Dawn of Justice (2016)",
#                   "Mission: Impossible - Rogue Nation (2015)",
#                   "Minions (2015)")

movie_interest<-c("10754",
                  "58077",
                  "87590")
nei <- list()
edgeW <- list()
comId <- rep(0, 3)
for(i in 1 : 3) { 
  nodeID <- (1 : vcount(g))[V(g)$name == movie_interest[i]]
  tmp <- neighborhood(g, 1, V(g)[nodeID])
  nei[[i]] <- tmp[[1]][2 : length(tmp[[1]])]
  print(movie_interest[i])
  edge_weight <- rep(0, length(nei[[i]]))

  for(j in 1:length(nei[[i]])) {
    edge_weight[j] <- g[from = nodeID, to = nei[[i]][j]]
  }

  names(edge_weight) <- nei[[i]]
  edgeW[[i]] <- edge_weight
  edge_weight <- sort(edge_weight, decreasing = TRUE)
  nei_name <- as.numeric(names(edge_weight[1 : 5]))
  nei_name <- V(g)[nei_name]$name
  print(nei_name)
  comId[i] <- com$membership[nodeID]
  print(comId[i])
}

for(i in 1 : 3) {
  nodeS <- nei[[i]]
  neiR1 <- V(g)[nodeS]$Rate
  neiR1 <- as.numeric(neiR1)
  neiR1 <- neiR1[which(neiR1 != 0)]
  comNode <- (1 : vcount(g))[com$membership == comId[i]]
  comR2 <- V(g)[comNode]$Rate
  comR2 <- as.numeric(comR2)
  comR2 <- comR2[which(comR2 != 0)]
  
  
  r1 <- mean(neiR1)
  r2 <- mean(comR2) 
  edgeW[[i]] <- edgeW[[i]] / sum(edgeW[[i]])
  r1_p <- sum(as.numeric(V(g)[nodeS]$Rate) * edgeW[[i]])
  
  r_simple1 <- 0.5 * r1 + 0.5 * r2
  r_simple2 <- (sum(neiR1) + sum(comR2)) / (length(neiR1) + length(comR2))
  r_weightAdd1 <- 0.5 * r1_p + 0.5 * r2
  r_weightAdd2 <- (r1_p * length(neiR1) + sum(comR2)) / (length(neiR1) + length(comR2))
  
  print(movie_interest[i])
  print(r_simple1)
  print(r_simple2)
  print(r_weightAdd1)
  print(r_weightAdd2)
}
