# Diferentes formas de graficar en r

# 1. graficar con base graphics (froma tradicional)
year <- c('2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018')
disney <- c(11, 13, 11, 8, 12, 11, 12, 8, 10)

# graficando con codigo
plot(x = year,
     y = disney)

# editando la grafica
plot(x = year,
     y = disney,
     main = 'disney',
     xlab = 'year',
     ylab = 'films',
     col = 'cornflowerblue',
     pch = 16,
     panel.first = grid())

# otras funciones para hacer gráficas básicas son 'barplot()', 'hist()', 'pie()' (diagrama de barras, histograma y diagrama de tarta)


# 2. graficar con ggplot2
# cargar paquete ggplot2
library(ggplot2)

# hacer dataframe
peliculas <- data.frame(year, 
                        disney)

# graficar utilizando ggplot
ggplot(data = peliculas,
       mapping = aes(x = year,
                     y = disney)) +
  geom_point() + 
  labs(title = 'disney')

# galería con código para graficar: https://www.r-graph-gallery.com/
# libro R Graphics Cookbook: https://r-graphics.org/

# otros paquetes para graficar
# Flexdashboard - para dashboards
# RGL - para gráficos en 3D
# Plotly - para gráficos interactivos
# Leaflet - para mapas
# RColorBrewer - para manejo de color avanzado