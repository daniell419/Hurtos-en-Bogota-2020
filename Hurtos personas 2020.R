### grafica de hurtos en bogota 

#Los datos se pueden descargar de: https://datosabiertos.bogota.gov.co/dataset/delito-de-alto-impacto-bogota-d-c

### cambiar por el directorio que descargaste los datos.
crimen_bogota <- readOGR(dsn = "D:/noveno semestre/big data/problem set 3/dataPS3", layer = "DAIUPZ", GDAL1_integer64_policy = TRUE)
crimen_bogota <- spTransform(crimen_bogota, CRS("+proj=longlat +datum=WGS84 +no_defs"))
crimen_bogota = st_as_sf(crimen_bogota)

## quita algunas localidades que no son de interes
crimen_bogota = subset(crimen_bogota, select = c(CMHP20CONT, CMIUUPLA, CMNOMUPLA)) %>% 
  filter(grepl("Rio",CMNOMUPLA)==FALSE)


## una paleta de colores azul.
bins <- c(0, 100, 200, 300, 400, 500, 600, 700, Inf)
palcustomizable <- colorBin(
  palette = "Blues",
  domain = crimen_bogota$CMHP20CONT, bins = bins)

pal_auto <- colorNumeric(
  palette = "Blues",
  domain = crimen_bogota$CMHP19CONT)

## anadir los labels
labels <- sprintf(
  "<strong>%s</strong><br/>%g hurtos a persona",
  crimen_bogota$CMNOMUPLA, crimen_bogota$CMHP20CONT
) %>% lapply(htmltools::HTML)


leaflet() %>% addTiles() %>% addPolygons(data=crimen_bogota,
                                         fillColor = ~pal_auto(CMHP20CONT),
                                         weight = 2,
                                         opacity = 1,
                                         color = "white",
                                         dashArray = "2",
                                         fillOpacity = 1,
                                         highlightOptions = highlightOptions(
                                           weight = 5,
                                           color = "#666",
                                           dashArray = "",
                                           fillOpacity = 0.7,
                                           bringToFront = TRUE),
                                         label = labels,
                                         labelOptions = labelOptions(
                                           style = list("font-weight" = "normal", padding = "3px 8px"),
                                           textsize = "15px",
                                           direction = "auto")) %>% 
  addLegend(pal = pal_auto, values = crimen_bogota$CMHP20CONT, opacity = 0.7, title = NULL, position = "bottomright")
