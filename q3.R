library("igraph")
library("netrw")
library("hash")
library(e1071)
#################Q2 Q3####################
g<-read.graph("/Users/stephanieyu/Desktop/232/final/edge_list.txt",format="ncol",directed=TRUE)
File_actorID<-file("/Users/stephanieyu/Desktop/232/final/actormap.txt",open="r")
actorID_map<-readLines(File_actorID,encoding="latin1")

p_rScore<-page.rank (g, algo = c("prpack", "arpack", "power"),
                     directed = TRUE, damping = 0.85,
                     weights = NULL) 
p_rScore1<-sort(p_rScore$vector,decreasing=TRUE)
id<-NULL
for(i in 1:10)
{
  id<-as.numeric(names(p_rScore1[i]))
  actor_ID<-actorID_map[id+1]
  aline=strsplit(actor_ID,"\t\t")
  print(aline[[1]][1])
  print(p_rScore1[i])
}

namelist<-c("DiCaprio, Leonardo","Hemsworth, Chris","Norton, Edward (I)","Pratt, Chris (I)","Clark, Elisa",
            "Paltrow, Gwyneth", "Howard, Terrence (I)","Portman, Natalie","Roberts, Julia (I)","Theron, Charlize")
actorID<-c(35919,59283,102312,112039,170161,216306,62628,63081,64002,66974)
actor_score<-hash()
for(i in 1:length(p_rScore$vector))
{
  for(j in 1:10)
  {
    id<-actorID[j]
    if(names(p_rScore$vector[i])==id)
    {
      .set(actor_score,keys=namelist[j],values=p_rScore$vector[i])
    }
  }
}
print(values(actor_score,keys=namelist))

close(File_actorID)

g_U<-as.undirected(g,mode="collapse",edge.attr.comb=list(weight="mean"))
sorted_weight<-sort(E(g_U)$weight,index.return=TRUE,decreasing=TRUE)
for(i in 1:10)
{
  sap=sorted_weight$ix[i]
  print(sorted_weight$x[i])
  print(E(g_U)[sap])
}

