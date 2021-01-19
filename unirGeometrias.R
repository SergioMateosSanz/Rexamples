# Gerometrías con ggplot2

# Plantilla básica para (casi) cualquier gráfico
#   ggplot(data = <DATA>,
#          mapping = aes(<MAPPINGS>)) +
#       <GEOM_FUNCTION<()

library(ggplot2)

data("iris")

# Ejemplo 1: Caso puntos y líneas
ggplot(data = iris,
       mapping = aes(x = Sepal.Length,
                     y = Sepal.Width,
                     color = Species)) +
  geom_point() +
  geom_smooth(method = 'lm')
  
# Ejemplo 2: Caso varías líneas
# una línea
ggplot(data = iris[iris$Species == 'setosa', ],
       mapping = aes(x = 1:50,
                     y = Petal.Width)) +
  geom_line()

# todas las líneas
ggplot(data = iris,
       mapping = aes(x = rep(1:50, 3),
                     y = Petal.Width,
                     color = Species)) +
  geom_line()

# Ejemplo 3: Caso boxplot y puntos
ggplot(data = iris,
       mapping = aes(x = Species,
                     y = Petal.Width,
                     fill = Species)) +
  geom_boxplot() + 
  geom_jitter()