# La lista es una colección ordenada de objetos dónde puede haber diferentes tipos

#####################################
# correr esto antes de empezar… 
#####################################

# informacion peliculas shrek.
nombre <- c("Shrek", "Shrek 2", "Shrek Tercero", "Shrek: Felices por siempre")
puntuacion <- c(7.9, 7.2, 6.1, 6.3)
posterior2005 <- c(FALSE, FALSE, TRUE, TRUE)
# informacion estrenos de peliculas.
warner <- c(20, 20, 16, 17, 17, 22, 17, 18, 19)
disney <- c(11, 13, 11, 8, 12, 11, 12, 8, 10)
fox <- c(18, 15, 15, 15, 16, 17, 15, 13, 11)

# crear diferentes estructuras de datos en R
vectorTitulos <- nombre
matrizPeliculas <- matrix(c(warner, disney, fox),
                           nrow = 9,
                           ncol = 3)
peliculasDF <- data.frame(nombre,
                           puntuacion,
                           posterior2005)

####################################
# rear una lista en R 
####################################

# crear lista en R
listaPrueba <- list(vectorTitulos,matrizPeliculas)

# mostrar lista
listaPrueba

# cambiar nombre de dataframe
names(listaPrueba) <- c('vector','matriz')


# mostrar lista (sí, otra vez)
listaPrueba

##################################################
# Seleccionar elementos de una lista
##################################################

# Seleccionar vector de la lista
listaPrueba[['vector']]

# Seleccionar el tercer elemento del vector de la lista
listaPrueba[['vector']][3]

# Seleccionar fila 5 y columna 3 de la matriz de la lista
listaPrueba[['matriz']][5,3]

######################################################
# agregar/eliminar elementos a una lista
######################################################

# agregar dataframe a lista
listaPrueba[['dataFrame']] <- peliculasDF

# revisar que está el dataframe
listaPrueba

# eliminar un elemento de lista
listaPrueba[['vector']] <- NULL

# revisar que no está el vector
listaPrueba

