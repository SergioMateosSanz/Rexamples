# histogramas en R. Es una gráfica de barras con la distribución de la frecuencia.
# la frecuencia es la cantidad de veces que se repite algo
# y la distribución es cómo se reparten en una variable

# 1. histogramas con base graphics

# cargando los datos (dataframe existente en R)
data("mtcars")

# haciendo histograma básico
hist(mtcars$hp)

# editando histograma
hist(mtcars$hp,
     #breaks = 50
     breaks = seq(50, 350, 50),
     col = 'darkgray',
     border = 'gray10',
     main = 'titulo',
     xlab = 'variable x',
     ylab = 'cantidad')

# 2. histogramas con ggplot2

# cargar ggplot2
library(ggplot2)

# hacer un histograma en ggplot2
ggplot(data = mtcars,
       mapping = aes(x = hp)) +
  geom_histogram(bins = 9)

# haciendo más cosas interesantes
ggplot(data = mtcars,
       mapping = aes(x = hp,
                     fill = factor(vs))) +
  geom_histogram(bins = 9,
                 position = 'identity',
                 alpha = 0.8) +
  labs(title = 'titulo',
       Fill = 'vs motor',
       x = 'caballos de fuerza',
       y = 'cantidad',
       subtitle = 'subtitulo',
       caption = 'fuente de los datos: R')

# dataset:
data2=data.frame(value=rnorm(100))

# basic histogram (https://www.r-graph-gallery.com/220-basic-ggplot2-histogram.html)
ggplot(data2, aes(x=value)) + 
  geom_histogram()

