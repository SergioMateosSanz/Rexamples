# author: Alex Rayón
# date: Octubre, 2020

# Antes de nada, limpiamos el workspace, por si hubiera algún dataset o información cargada
rm(list = ls())

# Cambiar el directorio de trabajo
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

# Vamos a cargar las librerías necesarias
library(dplyr)
library(caret)
library(funModeling)

# Leemos el dataset de clientes de una empresa de telecomunicaciones
estancias <- read.csv("data/duracionEstancia.csv")

# Vamos a hacer un poco de exploración de datos
str(estancias)

#############################################################################################
# ESTANCIAS
#############################################################################################
# Aquí explicación de todas las variables
# https://revolution-computing.typepad.com/.a/6a010534b1db25970b01b8d280d87b970c-pi
# Aquí  más información: https://blog.revolutionanalytics.com/2017/05/hospital-length-of-stay.html
#############################################################################################
# 1. Identificador único de la admisión en el hospital
colnames(estancias)[1]<-"idAdmision"
estancias$idAdmision<-as.factor(estancias$idAdmision)

# 2. Fecha de visita
colnames(estancias)[2]<-"fechavisita"
estancias$fechavisita<-as.factor(estancias$fechavisita)

# 3. Número de readmisiones últimos 180 días
colnames(estancias)[3]<-"numReadmisiones"
estancias$numReadmisiones<-as.numeric(estancias$numReadmisiones)

# 4. Género
colnames(estancias)[4]<-"genero"
estancias$genero<-ifelse(estancias$genero=="M",0,1)
estancias$genero<-as.factor(estancias$genero)

# 5. Flag de enfermedad renal
colnames(estancias)[5]<-"renal"
estancias$renal<-as.factor(estancias$renal)

# 6. Flag de asma
colnames(estancias)[6]<-"asma"
estancias$asma<-as.factor(estancias$asma)

# 7. Flag de falta de hierro
colnames(estancias)[7]<-"faltaHierro"
estancias$faltaHierro<-as.factor(estancias$faltaHierro)

# 8. Flag de pneumonia
colnames(estancias)[8]<-"pneumonia"
estancias$pneumonia<-as.factor(estancias$pneumonia)

# 9. Flag de dependencia de sustancias
colnames(estancias)[9]<-"dependenciaSustancias"
estancias$dependenciaSustancias<-as.factor(estancias$dependenciaSustancias)

# 10. Flag de desorden psicológico
colnames(estancias)[10]<-"desordenPsicologico"
estancias$desordenPsicologico<-as.factor(estancias$desordenPsicologico)

# 11. Flag de depresión
colnames(estancias)[11]<-"depresion"
estancias$depresion<-as.factor(estancias$depresion)

# 12. Flag de otros desórdenes psiquicos
colnames(estancias)[12]<-"otrosDesordenesPsiquicos"
estancias$otrosDesordenesPsiquicos<-as.factor(estancias$otrosDesordenesPsiquicos)

# 13. Flag de fibrosis
colnames(estancias)[13]<-"fibrosis"
estancias$fibrosis<-as.factor(estancias$fibrosis)

# 14. Flag de malnutrición
colnames(estancias)[14]<-"malnutricion"
estancias$malnutricion<-as.factor(estancias$malnutricion)

# 15. Flag de desórdenes en la sangre
colnames(estancias)[15]<-"desordenSangre"
estancias$desordenSangre<-as.factor(estancias$desordenSangre)

# 16. Valor hematocrito (g/dL)
colnames(estancias)[16]<-"hematocrito"
estancias$hematocrito<-as.numeric(estancias$hematocrito)

# 17. Valor neutrófilos (células/microL)
colnames(estancias)[17]<-"neutrofilos"
estancias$neutrofilos<-as.numeric(estancias$neutrofilos)

# 18. Valor sodio (mmol/L)
colnames(estancias)[18]<-"sodio"
estancias$sodio<-as.numeric(estancias$sodio)

# 19. Valor glucosa (mmol/L)
colnames(estancias)[19]<-"glucosa"
estancias$glucosa<-as.numeric(estancias$glucosa)

# 20. Valor nitrógeno urea sangre (mg/dL)
colnames(estancias)[20]<-"ureaSangre"
estancias$ureaSangre<-as.numeric(estancias$ureaSangre)

# 21. Valor creatinina (mg/dL)
colnames(estancias)[21]<-"creatinina"
estancias$creatinina<-as.numeric(estancias$creatinina)

# 22. Valor BMI (kg/m2)
colnames(estancias)[22]<-"bmi"
estancias$bmi<-as.numeric(estancias$bmi)

# 23. Valor pulso (pulsaciones/minuto)
colnames(estancias)[23]<-"pulso"
estancias$pulso<-as.numeric(estancias$pulso)

# 24. Valor respiración (respiraciones/minuto)
colnames(estancias)[24]<-"respiracion"
estancias$respiracion<-as.numeric(estancias$respiracion)

# 25. Flag de diagnóstico secundario
colnames(estancias)[25]<-"diagnosticoSecundario"
estancias$diagnosticoSecundario<-as.factor(estancias$diagnosticoSecundario)

# 26. Fecha de alta
colnames(estancias)[26]<-"fechaAlta"
estancias$fechaAlta<-as.character(estancias$fechaAlta)

# 27. Número de readmisiones últimos 180 días
colnames(estancias)[27]<-"idHospital"
estancias$idHospital<-as.factor(estancias$idHospital)

# 28. Duración de la estancia
colnames(estancias)[28]<-"duracionEstancia"
estancias$duracionEstancia<-as.numeric(estancias$duracionEstancia)

# Vamos a cuidar todos los aspectos de calidad de datos
# 1. Perfilamos la estructura del dataset
df_status(estancias)

# Algunas de las métricas que obtenemos: 
# q_zeros: cantidad de ceros (p_zeros: en porcentaje)
# q_inf: cantidad de valores infinitos (p_inf: en porcentaje)
# q_na: cantidad de NA (p_na: en porcentaje)
# type: factor o numérico
# unique: cantidad de valores únicos

# ¿Por qué estas métricas son importantes?
#   - Ceros: Las variables con muchos ceros no serán muy útiles para los modelos. 
#         Pueden incluso llegar a sesgar mucho el modelo.
#   - NAs: Hay modelos que incluso excluyen filas que tengan NA (RF por ejemplo). 
#         Por ello, los modelos finales pueden tener sesgos derivados de que falten filas. 
#   - Inf.: Si dejamos los valores infinitos, va a haber funciones de R que no sepamos siquiera cómo trabajan. No genera coherencia.
#   - Tipo: Hay que estudiarlos bien, porque no siempre vienen con el formato adecuado, pese a que visualmente lo veamos.
#   - Único: Cuando tenemos mucha variedad en los diferentes valores de datos, podemos sufrir overfitting.

# Perfilamos los datos de entrada y obtenemos la tabla de estado
datos_status=df_status(estancias, print_results = F)

# Quitamos variables que tengan más de un 60% de valores a cero
# Gestión de valores únicos
#   Currency es constante, no nos aportará nada. ¿Por qué?
vars_to_remove=filter(datos_status, p_na > 60 | unique==1 | p_inf > 60)  %>% .$variable
vars_to_remove

# Dejamos todas las columnas salvo aquellas que estén en el vector que crea df_status 'vars_to_remove'
estancias=dplyr::select(estancias, -one_of(vars_to_remove))

# Vamos a hacer una gestión de outliers para limpiar los datos: ¿qué decisión tomamos en este caso?
estancias$outlier=FALSE
for (i in 1:ncol(estancias)-1){
  columna = estancias[,i]
  if (is.numeric(columna)){
    media = mean(columna)
    desviacion = sd(columna)
    estancias$outlier = (estancias$outlier | columna>(media+3*desviacion) | columna<(media-3*desviacion))
  }
}
# Marcamos los TRUE y FALSE
table(estancias$outlier)

# Separamos el dataframe donde tenemos los outliers... creo que merecen un buen estudio
datosOutliers = estancias[estancias$outlier,]

# Marcamos los outliers en el gr?fico, los eliminamos y dibujamos
estancias=estancias[!estancias$outlier,]

# Y ya no necesitamos que haya una columna "outlier"
estancias$outlier=NULL


#############################################################################################
#############################################################################################
# MODELADO
#############################################################################################
#############################################################################################
#############################################################################################
# 2. MODELADO - PREDICTIVO
#############################################################################################
# Vamos a quitar alguna variable para el entrenamiento: ¿por qué? 
variables_a_quitar <- c("idAdmision", "idHospital", "fechaAlta","fechavisita")
estancias <- dplyr::select(estancias, -one_of(variables_a_quitar))

# Para poder hacer frente a este problema, lo que hacemos es dividir unos datos para entrenamiento y otros 
#   para evaluar el modelo
# El paquete de R "caret" nos ayuda en eso.
set.seed(998)
indice <- createDataPartition(estancias$duracionEstancia, 
                              p = .75, 
                              list = FALSE)
training <- estancias[indice,]
testing <- estancias[ - indice,]
# Me voy a construir un dataframe para evaluar qué tal ha aprendido a predecir mi modelo
verificacionPredicciones <- subset(testing, select = c(duracionEstancia))

# 1. Entrenamos el primer modelo
parametrosEntrenamiento <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 10,
  repeats = 10)

# (1) Regresión lineal: LM
modelo_lm1 <- train(duracionEstancia ~ .,
                    data = training,
                    method = "lm",
                    trControl = parametrosEntrenamiento)

# Vamos a ver un resumen del modelo
summary(modelo_lm1)
# Vamos a ver su RMSE
modelo_lm1
# Lo representamos
verificacionPredicciones$modelo_lm1 <- predict(modelo_lm1,testing)

# A partir de aquí podemos tener en algunos casos problemas de tipos de da

#### CART (Classification And Regression Trees) ####
set.seed(400)
ctrl <- trainControl(method="repeatedcv",repeats = 3)

modelo_arbol <- train(duracionEstancia~ ., 
                 data = training, 
                 method = "rpart", 
                 trControl = ctrl, 
                 tuneLength = 20, 
                 metric = "RMSE")

# Vemos nuevamente los resultados
modelo_arbol
plot(modelo_arbol)
verificacionPredicciones$modelo_arbol <- predict(modelo_arbol,testing)


# Comprobamos la matriz de verificación