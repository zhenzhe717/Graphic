# Intro to heatmap
#https://www.youtube.com/watch?v=V-IRkO4NIHU
#https://gitlab.com/stragu/DSH/blob/master/R/heatmaps/heatmaps_intermediate.md
mtcars_mat<-data.matrix(mtcars)
class(mtcars_mat)
#METHOD 1: heatmap
heatmap (mtcars_mat)
heatmap(mtcars_mat,
        scale = "colum")
# scale="row" is by default,and the color would 
#centred at the direction of row
#color change--------------------------------
heatmap(mtcars_mat,
        scale = "colum",
        col=cm.colors(n=15))#n is the number of color we need
#heatmap is defaut, but we could use the cm.color
#Remove dendrogram----------------------------
heatmap(mtcars_mat,
        scale = "colum",
        Colv = NA)# without the dendrogram, the colum won't be orderd
#and back to the original order
#cleanup the environment-----------------
rm(list =ls())

#METHOD 2: heatmap2
library(gplots)
rawdata <- read.csv("https://raw.githubusercontent.com/ab604/heatmap/master/leanne_testdata.csv")
#cleanup data
rawdata<-rawdata[,2:7]
colnames(rawdata)<-c(paste("Control",1:3,sep="_"),
                     paste("Treatment",1:3,sep="_"))
#convert to data.matrix
data_mat<-data.matrix(rawdata)
heatmap.2(data_mat)
#Error in plot.new() : figure margins too large
#enlarge the plot area first 
# In the heatmap2 method, scale is defaulted as "None", 
heatmap.2(data_mat, scale = "row")#we wanna see the conc. of each protein
#The heatmap.2 do cluster before scale, so the figure is a littele messy
#Scale the data BEFORE visualization
?scale
#it defaulted to scale through the colum direction, in our case, need to transpose the data
?t
data_scaled<-t(scale(t(data_mat)))
heatmap.2(data_scaled)
# more control over coors
my_palette<-colorRampPalette(c("blue",
                               "white",
                               "red"))# blue=low, white=medium, red=high
#this will call a function my_palette (n), n=the number of color you need 
heatmap.2(data_scaled,col = my_palette(20))
dev.off()
#the light blue lines are traces, whihc shows the mean value
heatmap.2(data_scaled,col= my_palette(20),trace = "none")
#if do not wanna cluster on the colum
heatmap.2(data_scaled,
          col = my_palette(20),
          trace = "none",
          Colv = NA,
          main = "A good title",
          margins = c(5,5),
          cexRow = 1,
          cexCol = 1)
#cex is font size, margin is aboutthe whole figure distance to the plot area 
#warning would appear since dendrgram for both is default, if wanna keep the clustered order (1,2,3,2,1,3)
#but do not wanna the dendrogram
heatmap.2(data_scaled,
          col = my_palette(20),
          trace="none",
          dendrogram = "row",
          main = "A good title",
          margins = c(5,5),
          cexRow = 1,
          cexCol = 1)

#if the figure stuck anywhere, use dev.off()
#clean the environment
rm (list=ls())
#METHOD 3:pheatmap::pheatmap()....

install.packages("pheatmap")
library(pheatmap)
?pheatmap
# creat random data
d<-matrix(rnorm(20),5,5)
colnames(d)<-paste0("Treatment",1:5)
rownames(d)<-paste0("Gene",1:5)
View (d)
#no need to put any sep="" between the names and their order No., so paste0 is good enough
#pheatmap
dev.off()
?pheatmap
pheatmap(d,
         main = "Pheatmap",
         cellwidth = 50,
         cellheight = 30,
         fontsize = 8,
         display_numbers = TRUE,
         scale = "row")
#THE pheatmap could define the cell height and width
#summary
#stats::heatmap():     scale (row) -> cluster -> colour (prefer order)
#gplots::heatmap.2():  cluster -> scale (none) -> colour  (so need to do scale first to generated scaled dataset)
#pheatmap::pheatmap(): scale (none) -> cluster -> colour

#METHOD 4 ggplot2 for dataframe
install.packages(ggplot2)
library(ggplot2)
#subset data
?esoph
esoph_sub<-subset(esoph,agegp=="55-64")
#visualize frequence of cancer
ggplot(esoph_sub, aes(x = alcgp,
                      y = tobgp,
                      fill = ncases / (ncases + ncontrols))) +
        geom_tile(colour = "white") + # grid colour
        scale_fill_gradient(low = "white",
                            high = "red") +
        theme_minimal() +
        labs(fill = "Cancer freq.",
             x = "Alcohol consumption",
             y = "Tobacco consumption")
#add a line to show the change
