

library(sf)
library(ggplot2)
library(tidyverse)
library(ggnewscale)
library(raster)
library(extrafont)      # custom font
library(hrbrthemes)     # to use import_roboto_condensed()
library(ggthemes)
library(elevatr)
library(tmap)

Poligon       = st_read("SHP/Geotermal_Peru.shp")
Poligo        <- st_transform(Poligon ,crs = st_crs("+proj=longlat +datum=WGS84 +no_defs"))
Pais          <- getData('GADM', country='Peru', level=1) %>% st_as_sf()
Pais_Elev     <- getData('alt', country='Peru')
#Pais_Elev2    = get_elev_raster(Pais, z=10)
plot(Pais_Elev )

slope = terrain(Pais_Elev  , opt = "slope") 
aspect = terrain(Pais_Elev  , opt = "aspect")
hill = hillShade(slope , aspect, angle = 40, direction = 270)

colss <-c("#ffd60a", "#70e000", "#ff8800", "#fec89a", "#ff0000", "#147df5")

Mapa= tm_shape(hill) +
  tm_raster(palette = gray(0:10 / 10), n = 100, legend.show = FALSE)+
  tm_shape(Pais_Elev) +
  tm_raster(alpha = 0.4, palette = RColorBrewer::brewer.pal(n = 10, name = "Greys") ,n=100, style="cont",
             legend.show = FALSE, title="Elevacion \n(m.s.n.m)")+
  tm_shape(Poligo)+
  tm_polygons("NOMBRE", style="quantile", palette = colss , n=6, legend.show = T,alpha = 0.6,
              title="Zonas potenciales  \npara la produccion \nde Geotermina")+
  tm_shape(Pais)+
  tm_borders("white",lwd=2)+
  tm_text("NAME_1",size = .8, col="black",shadow=TRUE,
          bg.color="white", bg.alpha=.35)+
  tm_scale_bar(width = 0.25, text.size = 0.5, text.color = "black", color.dark = "lightsteelblue4", 
               position = c(.01, 0.005), lwd = 1, color.light= "white")+
  tm_compass(type="8star", position=c(.01, 0.85), text.color = "black")+
  tm_layout( bg.color="white", 
             legend.title.size=.9,
             legend.position = c(0.005,0.10) , scale=0.91, legend.frame = F)+
  tm_credits("La Geotermia en \n       Peru", position = c(.58, .9), col = "Black", fontface="bold", size=2, fontfamily = "serif")+
  tm_credits("Data: Vargas y Cruz (2010) \n#Aprende R desde Cero Para SIG \nIng. Gorky Florez Castillo", position = c(0.1, .04), col = "black", fontface="bold")+
  tm_logo(c("https://www.r-project.org/logo/Rlogo.png",
            system.file("img/tmap.png", package = "tmap")),height = 3, position = c(0.40, 0.05))

tmap_save(Mapa, "Mapa/Mapa de potenciales de Geotermina.png", dpi = 1200, width = 9, height = 13)

