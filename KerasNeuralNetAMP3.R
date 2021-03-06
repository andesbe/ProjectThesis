#Reading the .csv files generated by the Matlab model
input <- read.csv(file="AmpIn.csv")
output <- read.csv(file="AmpOut.csv")


# Neural Network Visualization
library(keras)
library(mlbench) 
library(dplyr)
library(magrittr)
library(neuralnet)

#Transforming the output to log scale, as this is usually better. This info comes form experience, not peer reviewed data.
output <- log(output)

#Putting everything back into a dataframe and naming the columns. 
data <- cbind(input, output)
colnames(data) <- c("alpha", "wamin1", "wamin2", "Temp", "x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9", "x10", "x11", "x12", "x13", "x14", "x15", "y1", "y2", "y3", "y4", "Pt", "I")

str(data)

#Splitting data into a training, and a validation set. And transforming them into the appropriate data type. In this case a matrix. 
dt = sort(sample(nrow(data), nrow(data)*.8))
train<-data[dt,]
test<-data[-dt,]


set.seed(1234)
training <- train[1:4]
testing <- test[1:4]
trainingtarget <- train[5:24]
testingtarget <- test[5:24]

str(trainingtarget)
str(training)
x.train <- training
x.test <- testing

x.train <- as.matrix(x.train)
x.test <- as.matrix(x.test)

y.train <- as.matrix(trainingtarget)
y.test <- as.matrix(testingtarget)

#Scaling the input variables from 0 -> 1. The network converges easier and more accurately if the variables are in the same domain. 
mean <- apply(x.train, 2, mean)
std <- apply(x.train, 2, sd)
x.train <- as.array(scale(x.train, center = mean, scale = std))
x.test <- as.array(scale(x.test, center = mean, scale = std))



#Creating the model itself
model <-keras_model_sequential()%>%
  layer_dense(units = 80, activation = "relu", input_shape =c(4))%>%
  layer_dropout(0.35) %>%
  layer_dense(units = 20, activation = "linear")

model%>%
  compile(optimizer = "ADAM", loss = "mape") #Using Adaptive Momentum Optimizer, should also look more into using other optimizers, but ADAM seems very promising


history <- model%>%
  fit(x.train, y.train, epochs = 500, batch_size = 50, validation_split = 0.2)


#Evaluating the testing set, and transforming the predicted set back from the log scale 
model %>% evaluate(x.test, y.test)
pred <- model %>% predict(x.test)

pred <- exp(pred)
y.test <- exp(y.test)


#Finding Mean Absolute Percentage Error
mse1 <- abs(mean((as.vector(pred[,1]) -as.vector(y.test[,1]))/as.vector(pred[,1])))
mse2 <- abs(mean((as.vector(pred[,2]) -as.vector(y.test[,2]))/as.vector(pred[,2])))
mse3 <- abs(mean((as.vector(pred[,3]) -as.vector(y.test[,3]))/as.vector(pred[,3])))
mse4 <- abs(mean((as.vector(pred[,4]) -as.vector(y.test[,4]))/as.vector(pred[,4])))
mse5 <- abs(mean((as.vector(pred[,5]) -as.vector(y.test[,5]))/as.vector(pred[,5])))
mse6 <- abs(mean((as.vector(pred[,6]) -as.vector(y.test[,6]))/as.vector(pred[,6])))
mse7 <- abs(mean((as.vector(pred[,7]) -as.vector(y.test[,7]))/as.vector(pred[,7])))
mse8 <- abs(mean((as.vector(pred[,8]) -as.vector(y.test[,8]))/as.vector(pred[,8])))
mse9 <- abs(mean((as.vector(pred[,9]) -as.vector(y.test[,9]))/as.vector(pred[,9])))
mse10 <- abs(mean((as.vector(pred[,10]) -as.vector(y.test[,10]))/as.vector(pred[,10])))
mse11 <- abs(mean((as.vector(pred[,11]) -as.vector(y.test[,11]))/as.vector(pred[,11])))
mse12 <- abs(mean((as.vector(pred[,12]) -as.vector(y.test[,12]))/as.vector(pred[,12])))
mse13 <- abs(mean((as.vector(pred[,13]) -as.vector(y.test[,13]))/as.vector(pred[,13])))
mse14 <- abs(mean((as.vector(pred[,14]) -as.vector(y.test[,14]))/as.vector(pred[,14])))
mse15 <- abs(mean((as.vector(pred[,15]) -as.vector(y.test[,15]))/as.vector(pred[,15])))
mse16 <- abs(mean((as.vector(pred[,16]) -as.vector(y.test[,16]))/as.vector(pred[,16])))
mse17 <- abs(mean((as.vector(pred[,17]) -as.vector(y.test[,17]))/as.vector(pred[,17])))
mse18 <- abs(mean((as.vector(pred[,18]) -as.vector(y.test[,18]))/as.vector(pred[,18])))
mse19 <- abs(mean((as.vector(pred[,19]) -as.vector(y.test[,19]))/as.vector(pred[,19])))
mse20 <- abs(mean((as.vector(pred[,20]) -as.vector(y.test[,20]))/as.vector(pred[,20])))




MSE <- cbind(mse1, mse2, mse3, mse4, mse5, mse6, mse7, mse8, mse9, mse10, mse11, mse12, mse13, mse14, mse15, mse16, mse17, mse18, mse19, mse20)
colnames(MSE) <- c("x1 mape", "x2 mape", "x3 mape", "x4 mape", "x5 mape", "x6 mape", "x7 mape", "x8 mape", "x9 mape", "x10 mape", "x11 mape", "x12 mape", "x13 mape", "x14 mape", "x15 mape", "y1 mape", "y2 mape", "y3 mape", "y4 mape", "Pt mape")
MSE

MAPE <- mean(MSE)
MAPE
pred[1:10, 20]
y.test[1:10, 20]

#get_weights(model)

#Reduce the mole fractions and pressure into two different models
