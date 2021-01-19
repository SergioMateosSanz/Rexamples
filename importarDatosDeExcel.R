# importar datos de excel a R

#####################################
# 1. Que necesitas antes de empezar #
#####################################

# cargar paquete readxl
library(readxl)

# buscar la ruta del archivo de excel
file.choose()

# Copiar ruta de la consola y guardar en variable
rutaExcel <- "/home/sergio/Documentos/R/ejemploParaImportarEnR.xlsx"

# como mirar las hojas de tu excel (retorna un vector con el nombre de las hojas)
excel_sheets(rutaExcel)

#####################################
# 2. importar excel con código de R #
#####################################

# importar caso ideal (datos en la primera hoja y comienzan en la celda A1)
casoIdeal <- read_excel(rutaExcel)

# importar caso medio (datos que no comienzan en la primera hoja)
CasoMedio <- read_excel(rutaExcel,
                        sheet = 'Hoja2')

# importar caso dificil (datos que no comienzan en la primera hoja ni en la celda A1)
casoDificil <- read_excel(rutaExcel,
                          sheet = 'Hoja3',
                          range = 'C7:F17')

##########################################
# 3. importar excel con interfaz RStudio #
##########################################

# ir a File > Import Dataset > From Excel...

# para realizar la operativa con el paquete 'xlsx'
# data <- read.xlsx('datafile.xlsx', 1)
# para versiones anteriores de excel: data <- read.xls('datafile.xls')
ruta2Excel <- "/home/sergio/Documentos/R/ejemplo2ParaImportarEnR.xlsx"
library(xlsx)
data <- read.xlsx(ruta2Excel, 1)