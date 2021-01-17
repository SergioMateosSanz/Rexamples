# Un dataframe es una estructura de datos dónde se utilizan diferentes tipos de variables

#####################################
# correr esto antes de empezar…   #
#####################################

# vectores sobre peliculas de Shrek
nombre <- c("Shrek", "Shrek 2", "Shrek Tercero", "Shrek: Felices por siempre")
puntuacion <- c(7.9, 7.2, 6.1, 6.3)
posterior2005 <- c(FALSE, FALSE, TRUE, TRUE)

#######################################
# crear un dataframe en R 
#######################################

# crear dataframe de vectores
peliculasDF <- data.frame(nombre, puntuacion, posterior2005)

# mostrar dataframe
peliculasDF

# cambiar nombre de dataframe (normalmanete toma el nombre de los vectores pasados al DataFrame)
names(peliculasDF) <- c('NOMBRE','PUNTUACION','POSTERIOR2005')

# mostrar dataframe (sí, otra vez)
peliculasDF

#####################################################
# eleccionar elementos de un dataframe 
#####################################################

# seleccionar un elemento del dataframe
peliculasDF[3,2]
peliculasDF[3,'PUNTUACION']

# seleccionar más de un elemento del dataframe
peliculasDF[c(3,4),c(2,3)]
peliculasDF[c(3,4),c('PUNTUACION','POSTERIOR2005')]

# seleccionar una fila del dataframe
peliculasDF[3,]

# seleccionar una columna del dataframe
peliculasDF[,2]
peliculasDF[,'PUNTUACION']
peliculasDF$PUNTUACION

#################################
# ordenar dataframe 
#################################

# mostrar el indice de la columna de puntuacion con order
order(peliculasDF$PUNTUACION)

# funcion order (menor a mayor)
ordenMenorMayor <- order(peliculasDF$PUNTUACION, decreasing=FALSE)

# mostrar el dataframe ordenado
peliculasDF[ordenMenorMayor,]

# funcion order (mayor a menor)
ordenMayorMenor <- order(peliculasDF$PUNTUACION, decreasing=TRUE)

# mostrar el dataframe ordenado
peliculasDF[ordenMayorMenor,]

# guardar el dataframe ordenado
dFOrdenado <-   peliculasDF[ordenMayorMenor,]
