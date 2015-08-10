# ggplot2 types

# Setup:
inputData <- cars
x <- cars$speed
y <- cars$dist
plotTitle <- "Cars"
xlab <- "Speed"
ylab <- "Dist"

# Styling
mytitles <- labs(title="Cars", x="Speed", y="Dist")
mythemes <- theme(plot.title=element_text(size=20, colour = "firebrick"), axis.title.x=element_text(size=15), axis.title.y=element_text(size=15))

# 1. Scatterplot
gg <- ggplot(cars, aes(dist, speed)) + labs(title="Cars", x="Speed", y="Dist")
gg1 <- gg + theme(plot.title=element_text(size=20, colour = "firebrick"), axis.title.x=element_text(size=15), axis.title.y=element_text(size=15))
gg1 + geom_point()

# (or)
gg <- ggplot(cars, aes(dist, speed))
gg1 <- gg + mytitles + mythemes
gg1 + geom_point()

# 2. Histogram
gg <- ggplot(cars, aes(speed))
# gg1 <- gg + mythemes + mytitles     # Try this first. mytitles give a wrong Y axis title
gg1 <- gg + labs(title="Cars$Speed")
gg1 + geom_histogram()  # default 3 bins

# bin width
gg1 + geom_histogram(binwidth=0.5, color=3, fill="blue")
gg1 + geom_histogram(binwidth=1)
gg1 + geom_histogram(binwidth=5)

# 3. geom_bar() # same as histogram.
gg <- ggplot(cars, aes(speed)) + labs(title="Cars$speed")
gg + geom_bar()

# How to plot a histogram, but plotted for static values, rather than doing a counts on the variable.
myData <- data.frame(NAME=c("a", "b", "c"), VALUE=c(10, 20, 25))
gg <- ggplot(myData, aes(x=NAME, y=VALUE))
gg + geom_bar(stat="identity", aes(fill=VALUE),  color="black")
gg + geom_bar(stat="identity", fill="blue",  color="black")
gg + geom_histogram(stat="identity")

# 4. Density, Freq_poly
gg <- ggplot(cars, aes(speed)) + labs(title="Cars$speed")
gg + geom_density(fill="blue")

# 5. Jitter. A small error term is introduced so the values will be slightly different from the real values.
gg <- ggplot(cars, aes(speed, dist)) + labs(title="Cars")
gg + geom_point()
gg + geom_jitter()

myData <- data.frame(X=1:100, Y=1:100)
gg <- ggplot(myData, aes(X, Y)) + labs(title="Straight line")
gg + geom_point()
gg + geom_jitter() # slightly varied fried from the actual values.

# 6. Box Plot
gg <- ggplot(mtcars, aes(factor(cyl), mpg)) + labs(title="mtcars", x="cyl", y="mpg") + theme(plot.title=element_text(size=20, colour = "firebrick"), axis.title.x=element_text(size=15), axis.title.y=element_text(size=15))
gg + geom_boxplot()

# 7. Line
gg <- ggplot(economics, aes(date, pop)) + labs(title="economics", x="date", y="pop") + theme(plot.title=element_text(size=20, colour = "firebrick"), axis.title.x=element_text(size=15), axis.title.y=element_text(size=15))
gg + geom_line()

# ggplot can't deal with ts object.
gg <- ggplot(AirPassengers, aes(AirPassengers)) + labs(title="AirPassengers", x="AirPassengers") + theme(plot.title=element_text(size=20, colour = "firebrick"), axis.title.x=element_text(size=15), axis.title.y=element_text(size=15))
gg + geom_line()  # Error: geom_line requires the following missing aesthetics: y

# from a ts object
DATE <- seq.Date(as.Date("1949-01-01"), by="month", length=length(AirPassengers))
AP <- data.frame(AirPassengers=as.numeric(AirPassengers), DATE=DATE)
gg <- ggplot(AP, aes(DATE, AirPassengers)) + labs(title="AirPassengers", x="DATE", y="AirPassengers") + theme(plot.title=element_text(size=20, colour = "firebrick"), axis.title.x=element_text(size=15), axis.title.y=element_text(size=15))
gg + geom_line()

# 10. autoplot
# ggfortify
devtools::install_github('sinhrks/ggfortify')
library(ggfortify)
autoplot(AirPassengers) + labs(title="JohnsonJohnson") 
autoplot(JohnsonJohnson) + labs(title="JohnsonJohnson") + theme(plot.title=element_text(size=20, colour="firebrick"))

# 8. Ribbon
# We'll use the same dataframe we created from AirPassengers.
DATE <- seq.Date(as.Date("1949-01-01"), by="month", length=length(AirPassengers))
AP <- data.frame(AirPassengers=as.numeric(AirPassengers), DATE=DATE)
gg <- ggplot(AP, aes(DATE, AirPassengers)) + labs(title="AirPassengers", x="DATE", y="AirPassengers") + theme(plot.title=element_text(size=20, colour = "firebrick"), axis.title.x=element_text(size=15), axis.title.y=element_text(size=15))

# only border has steelblue
gg + geom_ribbon(ymin=AirPassengers-10, ymax=AirPassengers+10, color="steelblue")

# now fill with steelblue
gg + geom_ribbon(ymin=AirPassengers-10, ymax=AirPassengers+10, color="steelblue", fill="steelblue")

# increase the thickness
gg + geom_ribbon(ymin=AirPassengers-25, ymax=AirPassengers+25, fill="yellow1", color="blue")

# Now add a center line with geom_line(color="firebrick")
gg + geom_ribbon(ymin=AirPassengers-25, ymax=AirPassengers+25, fill="yellow1", color="blue") + geom_line(color="firebrick")


# 9. Violin
gg <- ggplot(mtcars, aes(factor(cyl), mpg)) + labs(title="Violin plot on mtcars") + theme(plot.title=element_text(size=20, colour = "firebrick"), axis.title.x=element_text(size=15), axis.title.y=element_text(size=15))
gg + geom_violin()
gg + geom_violin(trim=F)  # will show the full violin through the range of data.
gg + geom_violin(aes(fill=factor(cyl)), trim=F) 
gg + geom_violin(aes(fill=factor(cyl)), trim=F) + scale_fill_discrete(name="mpg")  # since we have used 'fill'.

