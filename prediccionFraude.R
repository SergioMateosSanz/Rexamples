# Autor: Alex Rayón (alex.rayon.jerez@gmail.com)
# Fecha: Febrero, 2021

# Antes de nada, limpiamos el workspace, por si hubiera algún dataset o información cargada
rm(list = ls())

# Cambiar el directorio de trabajo
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

# Vamos a cargar las librerías necesarias
# (1) Instalar la librería
# install.packages("tidyverse")
# (2) Cargar la memoria
library(tidyverse)
library(funModeling)
library(caret)

# Leemos los datos: pagos móviles PaySim
datos <- read_csv("data/datosFraude.csv")

#####################################
# METODOLOGÍA CRISP-DM
# 
#   1. Business understanding
#   2. Data understanding
#   3. Data preparation
#   4. Modeling
#   5. Evaluation
#   6. Deployment
#####################################

#####################################
# 1. Business understanding
#####################################

#####################################
# 2. Data understanding
#####################################
# Vamos a echar un vistazo a los datos
summary(datos)
str(datos)

# Parece que la primera columna nos sobra
datos<-datos[,-1]

#####################################
# 3. Data preparation
#####################################
# Vamos a estudiar los datos, por si podemos encontrar problemas de calidad de datos

# Otra manera de darnos cuenta de problemas con datos es a través de paquetes que permiten auditar datos
df_status(datos)
# ¿Qué vemos? ¿algún patrón raro?
# - Valores: cero, NA, infinitos, tipos, únicos
datos$tipo <- as.factor(datos$tipo)
datos$destino <- as.factor(datos$destino)
# Recodificamos
datos$esFraude <- as.factor(datos$esFraude)
datos$esFraude <- recode_factor(datos$esFraude, '0' = "No", '1' = "Si")

# Aprendemos a crear nuevas variables
horaCantidad<-datos%>%
  dplyr::group_by(as.factor(hora))%>%
  dplyr::summarize(cantidadTotal=sum(cantidad),
         cantidadMinima=min(cantidad),
         cantidadMaxima=max(cantidad),
         cantidadMedia=mean(cantidad))
names(horaCantidad)<-c("hora","cantidadTotal","cantidadMinima","cantidadMaxima","cantidadMedia")

operacionCantidad<-datos%>%
  dplyr::group_by(esFraude)%>%
  dplyr::summarize(cantidadMinima=min(cantidad),
            cantidadMaxima=max(cantidad),
            cantidadMediana=median(cantidad))

# Vamos a visualizarlo, para que se vea la utilidad de los datos resumidos
ggplot(data=horaCantidad, 
       mapping = aes(x=hora,y=cantidadTotal))+
  geom_point()
# ¿Se puede observar algún patrón?

# Vamos a explorarlo la distribución de los datos
boxplot(datos,las=2)

############################################################################################
# Pre-procesamos el dataset para el modelado
############################################################################################
# Vamos a tratar de localizar variables muy correlacionadas
fraud_numeric <- datos %>%
  select(-esFraude, -tipo, -destino)
str(fraud_numeric)
fraud_numeric<-as.data.frame(fraud_numeric)

# Vamos a sacar la matriz de correlación
library(corrplot)
cor(fraud_numeric)
corrplot(cor(fraud_numeric),method="circle")

#####################################
# 4. Modeling
#####################################
# Separamos los datos entre conjuntos de train y test
indice <- createDataPartition(y = datos$esFraude, 
                                p = .75, 
                                list = FALSE) 
train <- datos[indice, ] 
test <- datos[-indice, ] 

# Parámetros de entrenamiento del modelo
control <- trainControl(method = "repeatedcv", 
                        number = 10, 
                        repeats = 3, 
                        classProbs = TRUE, 
                        summaryFunction = twoClassSummary)

# Vamos a probar diferentes modelos: 
#   (1) Rpart
#   (2) NB
#   (3) LogitBoost
#   (4) knn

#   (1) Rpart
# https://cran.r-project.org/web/packages/rpart/rpart.pdf
# https://cran.r-project.org/web/packages/rpart/vignettes/longintro.pdf
start_time <- Sys.time()
modelo1 = train(esFraude ~ .,
                    data = train,
                    method = "rpart",
                    trControl = control)
end_time <- Sys.time()
end_time - start_time

# Vamos a sacar la importancia de las variables
plot(varImp(modelo1))

# Predecimos en Testing
predicciones <- predict(modelo1, test)
matrizConfusion<-confusionMatrix(test$esFraude, predicciones)
matrizConfusion

# (2) Random Forest (NB): modelos probabilísticos - Naives Bayes
library(e1071)
library(rminer)

# Entrenamos el modelo
start_time <- Sys.time()
modelo2 <- train(esFraude ~ ., 
                 data=train, 
                 trControl=control, 
                 method="nb")
end_time <- Sys.time()
end_time - start_time

# Hacemos predicciones
predicciones2<- predict(modelo2,test)
# Un resumen de resultados
matrizConfusion2<- confusionMatrix(predicciones2,
                                   test$esFraude)
matrizConfusion2

# (3) Me voy a volver a un modelo más básico
# Regresión logística
#   ¿Qué diferencia tiene con la regresión lineal? http://www.saedsayad.com/logistic_regression.htm
# Entrenamos el modelo
start_time <- Sys.time()
modelo3 <- train(esFraude~., 
                 data=train, 
                 trControl=control, 
                 method="LogitBoost")
end_time <- Sys.time()
end_time - start_time

# Hacemos predicciones
predicciones3<- predict(modelo3,
                        test)

# Matriz de confusión
matrizConfusion3<- confusionMatrix(predicciones3,
                                   test$esFraude)
matrizConfusion3

# (4) Otro modelo
# Entrenamos el modelo
start_time <- Sys.time()
modelo4 <- train(esFraude~., 
                 data=train, 
                 trControl=control, 
                 method="knn")
end_time <- Sys.time()
end_time - start_time

# Hacemos predicciones
predicciones4<- predict(modelo4,test)

# Un resumen de resultados
matrizConfusion4<- confusionMatrix(predicciones4,
                                   test$esFraude)
matrizConfusion4


#####################################
# 5. Evaluación de modelos
#####################################

#####################################
# 6. Despliegue y toma de decisiones
#####################################
