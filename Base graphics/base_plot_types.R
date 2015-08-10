# R Plots: Base graphics

# 1. How to plot multiple lines in an R plot?
set.seed(100)
x <- 1:20
y1 <- rnorm(20, 60, 20)
y2 <- rpois(20, 40)
y3 <- sample(20:35, 20, replace=T)

plot(x, y1, type="l", ylim=c(0,100), lwd=2, main="Multiple lines")
lines(y2, col="blue", lwd=4, lty=2)
lines(y3, col="green3", lwd=2)

# 2. How to make plot with 2 X axes and 2 Y axes?
plot(x, y1, type="l", ylim=c(0,100), lwd=2, main="Multiple Y axes", col="green3")
par(new=T)  # initialise new plot

# start drawing second y axis plot.
plot(x, y2, type="l", axes=F, xlab="", ylab="", lwd=2, col="red")
axis(4)  # draw second y axis.
legend("bottomleft",col=c("green3","red"),lty=1,legend=c("y1","y2"))


# 3. How to change the layout of the plot?

# 4. gplots see bubble charts on correspondence analysis post from sthda.com, correlogram, 