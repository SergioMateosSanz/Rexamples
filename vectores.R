# Un vector es un espacio de memoria usado para guardar información del mismo tipo de datos (unidimensional)
# --------------------------------------------

#####################################
# creando vectores en R 
#####################################

# crear vector carácter con nombre de las películas
nombre <- c("Shrek", "Shrek 2", "Shrek tercero", "Shrek: Felices para siempre")

# crear vector numérico con puntuación de las películas
puntuacion <- c(7.9, 7.2, 6.1, 6.3)

# crear vector lógico sobre si la película es posterior a 2015
posterior2005 <- c(FALSE, FALSE, TRUE, TRUE)

####################################################
# operaciones aritméticas con vectores 
####################################################

# sumar 2 a la puntuación
puntuacion + 2

# dividir la puntuación entre 2
puntuacion/2

# crea la puntuación de pepe
puntuacionPepe <- c(10, 9, 6, 8)

# calcular diferencia entre puntuaciones
puntuacionPepe - puntuacion

# calcular la longitud del vector
length(puntuacion)

# calcular el promedio del vector puntuacion
mean(puntuacion)

###################################################
# selección de elementos de un vector 
###################################################

## selección basada en posición
# seleccionar la tercera película
nombre[3]

# seleccionar la primera y la última película
nombre[c(1,4)]

## selección basada en condición lógica
# crear condición lógica
puntuacionBaja <- puntuacion < 7

# mostrar condición para ver TRUE/FALSE
puntuacionBaja

# mostrar puntuaciones bajas
puntuacion[puntuacionBaja]

# mostrar nombres de películas con puntuaciones bajas
nombre[puntuacionBaja]
