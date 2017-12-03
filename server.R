#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(ncdf4)
library(chron)
library(shiny)
library(sp)
library(rgdal)
library(raster)
library(tmap)
data(World)
#library(maptools)
# Define server logic required to draw a histogram
#setwd("D:/Moje dokumenty/Praca_magisterska/MagisterkaNetCDF/shiny-master/")

#

ncname <- "SBCAPE"#nazwa pliku
ncfname <- paste(ncname, ".nc", sep = "")
dname <- "SBCAPE" #parapmetr zmienny
ncin <- nc_open(ncfname)

lon <- ncvar_get(ncin, "lon")
nlon <- dim(lon)


lat <- ncvar_get(ncin, "lat", verbose = F)
nlat <- dim(lat)


t <- ncvar_get(ncin, "time")
tunits <- ncatt_get(ncin, "time", "units")
nt <- dim(t)



######################################################
tmp.array <- ncvar_get(ncin, dname)
dlname <- ncatt_get(ncin, dname, "long_name")
dunits <- ncatt_get(ncin, dname, "units")
fillvalue <- ncatt_get(ncin, dname, "_FillValue")
tustr <- strsplit(tunits$value, " ")
tdstr <- strsplit(unlist(tustr)[3], "-")
tmonth = as.integer(unlist(tdstr)[2])
tday = as.integer(unlist(tdstr)[3])
tyear = as.integer(unlist(tdstr)[1])
#chron(t, origin = c(tmonth, tday, tyear))

#tmp.array[tmp.array == fillvalue$value] <- NA
#tunits$value #  informacje o sposobie przechowywania czasu w pliku
czas <- as.POSIXct(t, origin="1970-01-01", tz='GMT')


#m <- 1
shinyServer(function(input, output) {

  output$czas <- renderUI({
    m <- input$bins
    titlePanel(paste(format(czas[m],"%Y-%m-%d %H:%M")))
  })
  
  output$distPlot <- renderPlot({
    colory <- c("white","cyan","green","yellow","orange", "red", "#600000")
    #colfunc <- colorRampPalette(c("white","cyan","green","yellow","orange", "red", "#600000"))
    m <- input$bins 
    tmp.slice <- tmp.array[, , m]
    grid <- expand.grid(lon = lon, lat = lat)
    
    lonlat <- expand.grid(lon, lat)
    tmp.vec <- as.vector(tmp.slice)
    length(tmp.vec)
    
    
    tmp.df01 <- data.frame(cbind(lonlat, tmp.vec))
    names(tmp.df01) <- c("lon", "lat", paste(dname, as.character(m), sep = "_"))
    pts <- tmp.df01
    colnames(pts) <- c("x","y","z")
    
    
    coordinates(pts)=~x+y
    proj4string(pts)=CRS("+init=epsg:4326") # set it to lat-long
    pts = spTransform(pts,CRS("+init=epsg:4326"))
    gridded(pts) = TRUE
    r = raster(pts)
    projection(r) = CRS("+init=epsg:4326")
    
    #writeRaster(r, filename=paste(format(czas[m],"%Y-%m-%d %H:%M"),".tif", sep=""), options=c('TFW=YES'))
    
    
    tm_shape(r, n.x = 5) +
      tm_raster(n=50,palette = colory, auto.palette.mapping = FALSE, interpolate = T, breaks = seq(0,4500, 250),
                title="CAPE \n[J/Kg^-2]", legend.show = F)+ 
      tm_format_Europe(title = NA, title.position = c("left", "top"),attr.outside=T,legend.outside=TRUE,
                       legend.text.size = 1.5,legend.outside.position=c("left"),
                       attr.position = c("right", "bottom"), legend.frame = TRUE,
                       inner.margins = c(.0, .0, 0, 0))+tm_scale_bar(size = 1)+
      tm_shape(World, unit = "km") +
      tm_polygons(alpha = 0)+
      tm_xlab("latitude", size = 1, rotation = 0)+
      tm_ylab("longitude", size = 1, rotation = 90)+
      tm_grid(x = c(-20,0,20,40,60),y=c(40,50,60,70,80), labels.inside.frame=T)+
    tmap_mode("plot")
  }, height = 700, width = 700)
  
  output$widget_temp <- renderPlot({
    m <- input$bins 

    tmp.slice <- tmp.array[, , m]
    grid <- expand.grid(lon = lon, lat = lat)
    
    lonlat <- expand.grid(lon, lat)
    tmp.vec <- as.vector(tmp.slice)
    length(tmp.vec)
    
    
    tmp.df01 <- data.frame(cbind(lonlat, tmp.vec))
    names(tmp.df01) <- c("lon", "lat", paste(dname, as.character(m), sep = "_"))
    pts <- tmp.df01
   plot(tmp.df01$SBCAPE, type="line")
    
  })
  
})

