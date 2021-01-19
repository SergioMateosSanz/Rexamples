# Importar archivos csv (Comma Sepparated Values ) a R


# cargar paquete readr
library(readr)

# buscar la ruta del archivo de csv
file.choose()

# Copiar ruta de la consola y guardar en variable
rutaCSV <- "/home/sergio/Documentos/R/gapminder.csv"


#####################################
#importar csv con código de R
#####################################

# importar datos gapminder
gapminder <- read_csv(rutaCSV)

# caso no titulo
rutaSinTitulo <- "/home/sergio/Documentos/R/gapminder_col_names.csv"
gapminderSinTitulo <- read_csv(rutaSinTitulo,
                               col_names = FALSE)

# para agregar nombre
gapminderConTitulo <- read_csv(rutaSinTitulo,
                                col_names = c('pais','anio','vida','pobacion'))

# caso punto y coma
rutaPuntoYComa <- "/home/sergio/Documentos/R/gapminder_puntoycoma.csv"
gapminderPuntoYComa <- read_csv2(rutaPuntoYComa)


########################################
# importar csv con interfaz RStudio
########################################

# ir a File > Import Dataset > From Text (readr)

# código que genera y ejecuta R automáticamente