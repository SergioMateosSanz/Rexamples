# Los factores es una estructura de datos para manejar variables categóricas(datos que toman una cantidad finita de valores)

#####################################
# correr esto antes de empezar… 
#####################################

# crear vector de ventas
tallas <- c('m', 'g', 'S', 'S','m', 'M')

# intentar graficar
plot(tallas)

###################################
# crear factores en R 
###################################

# crear factor de un vector
tallasFactor <- factor(tallas)

# graficar factor
plot(tallasFactor)

# mirar niveles de factor
levels(tallasFactor)

######################################
# recodificando factores
######################################

# creando factor recodificado
tallasRefactor <- factor(tallas,
                         levels = c("g","m","M","S"),
                         labels = c("G","M","M","S"))

# graficando ventas_recodificado
plot(tallasRefactor)

#############################################
# ordenando niveles de factores 
#############################################

# ordenando niveles (copiar factor anterior)
tallasOrdenado <- factor(tallas,
                         ordered = TRUE,
                         levels = c("S","m","M","g"),
                         labels = c("S","M","M","G"))

# viendo el orden en los niveles
tallasOrdenado

# graficando el factor ordenado
plot(tallasOrdenado)
