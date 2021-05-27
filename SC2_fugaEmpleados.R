# author: Alex Rayón
# date: Octubre, 2020

# Antes de nada, limpiamos el workspace, por si hubiera alg?n dataset o informaci?n cargada
rm(list = ls())

# Cambiar el directorio de trabajo
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

# Cargamos las librerías que vamos a necesitar
library(dplyr)
library(caret)
library(corrplot)

# Leemos los datos que vamos a necesitar para hacer este ejercicio
datos <- read.table("data/empleadosEmpresa.csv", header = T,sep=',')
head(datos)

# Vamos a renombrar todas las columnas
names(datos)<-c("nivelSatisfaccion","ultimaEvaluacion","numeroProyectos", "horasMediaMes",
                "antiguedad","accidenteTrabajo","salida","promocionUltimos5","departamento",
                "salario")

# vamos a cambiar los tipos de datos que necesitamos para predecir
datos$accidenteTrabajo<-as.factor(datos$accidenteTrabajo)
datos$salida<-as.factor(datos$salida)

# Exploración de datos
#   - Vamos a explorar los datos y entender dónde podría sufrir la calidad de los mismos.
#   - Medidas de tendencia central y variación.
summary(datos)

# Mapa de correlación entre cada par de variables. El tamaño de la burbuja revela el significado de cada correlación,
#   mientras que el color representa la dirección (positivo o negativo)
datos_cor <- datos[,c(1:5,8)]
M <- cor(datos_cor)
corrplot(M, method="circle")
cor(datos_cor)

########################################################################
# MODELADO
########################################################################
#   Visto esto, a mí me interesa predecir quién puede ser el siguiente en abandonar mi empresa
datos2 <- datos %>% filter(ultimaEvaluacion >= 0.70 | 
                         antiguedad >= 4 | 
                         numeroProyectos > 5)
summary(datos2)

# Cross-validation
#   ¿Qué es? ¿Qué implicaciones tiene? ¿Qué tipos hay?
#     https://es.wikipedia.org/wiki/Validaci%C3%B3n_cruzada#Tipos_de_validaciones_cruzadas 
parametrosEntrenamiento<- trainControl(method="cv", 
                             number=5)
head(parametrosEntrenamiento)

# Muestreamos los datos: 70 training - 30 test
indice = createDataPartition(datos2$salida, 
                             p = 0.8, 
                             times = 1, 
                             list=FALSE)
datosTrain = datos2[ indice,]
datosTest = datos2[-indice,]

# Entrenamos al modelo
modelo<- train(salida ~ .,
                   data=datosTrain,
                   trControl=parametrosEntrenamiento,
                   method="rpart")

# ¿Qué es el modelo?
modelo

# ¿Cuánto contribuye cada variable a clasificar o predecir la variable target?
imp <- varImp(modelo)

# Lo visualizamos
plot(imp)

#################################
# Hacemos predicciones
predicciones<- predict(modelo,
                       datosTest)

# Hacemos un resumen de los resultados obtenidos
matrizConfusion<- confusionMatrix(predicciones,
                                  datosTest$salida)
matrizConfusion

# Vamos a utilizar ahora el análisis ROC
#   http://mlwiki.org/index.php/ROC_Analysis
library("ROCR")
predicciones <- as.numeric(predicciones)
objeto <- prediction(predictions=predicciones, 
                     labels=datosTest$salida)
# Curva ROC
roc.obj <- performance(objeto, measure="tpr", x.measure="fpr")
par(mfrow=c(1,1))
plot(roc.obj,
      main="Cross-Sell - ROC Curves",
      xlab="1 – Specificity: False Positive Rate",
      ylab="Sensitivity: True Positive Rate",
      col="blue")
abline(0,1,col="grey")

# (2) Segundo algoritmo: modelo NB, que son  modelos probabilísticos
# Naives Bayes
library(e1071)
library(rminer)

# Entrenamos el modelo
modelo2 <- train(salida ~ ., 
                     data=datosTrain, 
                     trControl=parametrosEntrenamiento, 
                     method="nb")
plot(varImp(modelo2))

# Hacemos predicciones
predicciones2<- predict(modelo2,datosTest)
# Un resumen de resultados
matrizConfusion2<- confusionMatrix(predicciones2,
                                   datosTest$salida)
matrizConfusion2

# (3) Me voy a volver a un modelo más básico
# Regresión logística
#   ¿Qué diferencia tiene con la regresión lineal? http://www.saedsayad.com/logistic_regression.htm
# Entrenamos el modelo
modelo3 <- train(salida~., 
                  data=datosTrain, 
                  trControl=parametrosEntrenamiento, 
                  method="LogitBoost")
varImp(modelo3)
# Hacemos predicciones
predicciones3<- predict(modelo3,
                        datosTest)

# Matriz de confusión
matrizConfusion3<- confusionMatrix(predicciones3,datosTest$salida)
matrizConfusion3

# (4) Otro modelo
# Entrenamos el modelo
modelo4 <- train(salida~., 
                  data=datosTrain, 
                  trControl=parametrosEntrenamiento, 
                  method="knn")

varImp(modelo4)
# Hacemos predicciones
predicciones4<- predict(modelo4,datosTest)

# Un resumen de resultados
matrizConfusion4<- confusionMatrix(predicciones4,datosTest$salida)
matrizConfusion4


# Insights
#   - La matriz de confusión y la precisión nos explica la capacidad predictiva 
#   - 95% de precisión y un Kappa de 84%.
#   - El modelo de regresión logística nos ofrece buenos resultados, siendo un modelo sencillo.

# (5) Otro modelo
#   Un último modelo, vamos a jugar con las probabilidades
# Obtenemos los motivos de fuga de empleados
modelo5 = glm(salida ~ ., 
             family=binomial(logit), 
             data=datosTrain)

# Hacemos predicciones con los "out-of-sample" datos: es decir, los que "apartamos"
probabilidadFuga=predict(modelo5,
                     newdata=datosTest,
                     type="response")

# Estructuramos en un dataframe los motivos y su probabilidad de fuga
prediccionSalida = data.frame(probabilidadFuga)

# Añadimos la columnna de rendimiento del empleado, para poder centrarnos en aquellos mejores que tienen riesgo de fuga
prediccionSalida$rendimiento=datosTest$ultimaEvaluacion

# Lo representamos visualmente
par(mfrow=c(1,1))
plot(prediccionSalida$probabilidadFuga,
     prediccionSalida$rendimiento)

# Mostramos a continuación los 300 empleados que la empresa tendría que retener.
prediccionSalida$prioridad=
  prediccionSalida$rendimiento *
  prediccionSalida$probabilidadFuga

# Y ahora lo ordenamos para verlo en una tabla
ordenFuga=prediccionSalida[order(prediccionSalida$prioridad,decreasing = TRUE),]
ordenFuga <- head(ordenFuga, n=300)
# Lo representamos en una tabla de gestión
library(DT)
datatable(ordenFuga)
