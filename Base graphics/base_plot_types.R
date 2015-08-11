# R Plots: Base graphics

# 1. How to plot multiple lines in an R plot?
set.seed(100)
x <- 1:10
# y1 <- rnorm(20, 60, 20)
y1 <- c(1:10)
y2 <- rpois(10, 5)
y3 <- sample(4:7, 10, replace=T)

par(mar=c(5, 4, 4, 2) + 0.1)
plot(x, y1, type="b", ylim=c(0,12), lwd=2, main="Multiple lines", pch=16, col="red")
lines(y2, col="blue", lwd=3, lty=1)
lines(y3, col="green3", lwd=3, type="b", pch=15)

# 2. How to make plot with 2 X axes and 2 Y axes?
# set par(new=TRUE) to prevent R from clearing the graphics device, 
# creating the second plot with axes=FALSE (and setting xlab and ylab 
# to be blank – ann=FALSE should also work) and then using axis(side=4)
# to add a new axis on the right-hand side, and mtext(...,side=4)

par(mar=c(5, 4, 4, 5) + 0.1)
plot(x, y1, type="b", ylim=c(0,12), lwd=2, main="Multiple Y axes", col="green3", pch=16)
par(new=T)  # initialise new plot

# start drawing second y axis plot.
plot(x, y2, type="b", axes=F, xlab="", ylab="", lwd=2, col="red", pch=15, ylim=c(0,50))
axis(4, ylim=c(0,50))  # draw second y axis.
mtext("y2", side=4, line=3)
legend("bottomright",col=c("green3","red"),lty=1,legend=c("y1","y2"))


# 3. How to change the layout of the plot?

# Using layout()
par(mar=c(2,2,2,1))
myLayout <- layout(matrix(c(2, 0, 1, 3), byrow=T, nrow=2), widths = c(2, 1), heights = c(1, 2))
layout.show(myLayout)
plot(mtcars$wt, mtcars$mpg, xlab="Car Weight", ylab="Miles Per Gallon", main="Mpg Vs Wt")
boxplot(mtcars$wt, horizontal=TRUE, axes=FALSE, main="Wt")
boxplot(mtcars$mpg, axes=FALSE, main="Mpg")


# Using fig()
# Add boxplots to a scatterplot
par(fig=c(0,0.8,0,0.8), new=TRUE)
plot(mtcars$wt, mtcars$mpg, xlab="Car Weight", ylab="Miles Per Gallon")
par(fig=c(0,0.8,0.55,1), new=TRUE)
boxplot(mtcars$wt, horizontal=TRUE, axes=FALSE)
par(fig=c(0.65,1,0,0.8),new=TRUE)
boxplot(mtcars$mpg, axes=FALSE)
mtext("Enhanced Scatterplot", side=3, outer=TRUE, line=-3)

## Challenge:
xrange <- range(mtcars$mpg)
yrange <- range(mtcars$drat)
# par(mar=c(1,1,1,1))
nf <- layout(matrix(c(2,0,1,3),2,2,byrow=TRUE), c(3,1), c(1,3), TRUE)
layout.show(nf)
par(mar=c(4,3,1,1))
plot(mtcars$mpg, mtcars$drat, xlim=xrange, ylim=yrange, pch=21, col="red", bg="green", xlab="", ylab="")
mtext("mpg", 1, line=3)
mtext("drat", 2, line=3)
par(mar=c(0,3,3,1))
barplot(mtcars$mpg, axes=FALSE, col="green3",ylim=xrange, space=0, main="mpg vs draft")
par(mar=c(4,0,1,3))
barplot(mtcars$drat, axes=FALSE, col="green3", xlim=yrange, space=0, horiz=TRUE)
