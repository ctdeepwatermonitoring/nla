setwd("C:\\Users\\deepuser\\Documents\\Projects\\GISPrjs\\2022\\nla\\") #Set working directory

library(rgdal)
library(sp)
library(rgeos)
library(tmap)


########Simplify Polygon and Re-export###########
##Lake Polyline must have a defined projection.
#NLA 17 Lakes loaded with ESPG 2234 CT NAD83 coordinate system (in feet)

files <- list.files('data/ind_lakes/', pattern = '*.shp$')


for(file in files){
  l <- strsplit(file,".shp")[[1]] 
  Lake <- readOGR(paste0("data/ind_lakes/",file),layer=l) #Load the lake polyline
  
  plot(Lake)  #Plot the lake polyline
  LakePt<- spsample(Lake,n=10,"regular") #Randomly select 10 points around the lake
  LakePt<-spTransform(LakePt,CRS("+proj=longlat"))  #Transform coordinates to lat long
  
  LakePtData<- as.data.frame(LakePt)  #Save as a data frame (table)
  
  
  Station<- c("A","B","C","D","E","F","G","H","I","J")  #Create label for sample points
  LakePtData<-cbind(LakePtData,Station)  #Combine labels with lat long data
  colnames(LakePtData)<- c("long","lat","ident") #Rename columns
  LakePtData$comment<-Lake$LAKE #Add lake name from polyline file
  
  #Write table formatted for Garmin GPS upload using DNRGPS
  write.table(LakePtData,paste(Lake$LAKE,"PHABStations",".txt",sep=""),row.names=FALSE,
              quote=FALSE,sep="\t")
  
}


