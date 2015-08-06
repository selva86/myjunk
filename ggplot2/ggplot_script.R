# Prepare the data
rowIndex <- sample(1:nrow(diamonds), 0.01*nrow(diamonds))
dSmall <- diamonds[rowIndex, ]


qplot(carat, price, data=dSmall, geom=c("point", "smooth"))
qplot(carat, price, data=dSmall, geom=c("point", "smooth"), span=0.1)
qplot(carat, price, data=dSmall, geom=c("point", "smooth"), span=0.8)

# Adjust transparency (1/20 => 20 points needed to produce 1 fully opague point.)
qplot(carat, price, data=dSmall, geom=c("point", "smooth"), span=0.1, alpha=I(1/5))

library(mgcv)
# gam
qplot(carat, price, data=dSmall, geom=c("point", "smooth"), method="gam", formula=y ~ s(x))  # generalised additive model

# lm
qplot(carat, price, data=dSmall, geom=c("point", "smooth"), method="lm")  # fit a straight line

# robust regression (rlm)
library(MASS)
qplot(carat, price, data=dSmall, geom=c("point", "smooth"), method="rlm")  # fit a rlm line of best fit. Outliers have a lesser impact on the fitted line.

# splines
library(splines)
qplot(carat, price, data=dSmall, geom=c("point", "smooth"), method="lm", formula=y ~ ns(x, 5))  # natural splines

qplot(carat, price, data=dSmall, geom=c("point", "smooth"), method="lm", formula=y ~ poly(x, 3))  # 3rd degree polynomil

# Density
qplot(carat, data=dSmall, geom=c("density"))  # Density

# Density for each category of color
qplot(carat, data=dSmall, geom=c("density"), colour=color)  # Density

# Histogram
qplot(carat, data=dSmall, geom=c("histogram"), binwidth=1, xlim=c(0, 3))
qplot(carat, data=dSmall, geom=c("histogram"), binwidth=0.1, xlim=c(0, 3))
qplot(carat, data=dSmall, geom=c("histogram"), binwidth=0.01, xlim=c(0, 3))

# histgram based on color
qplot(carat, data=dSmall, geom=c("histogram"), fill=color)

# barchart
qplot(carat, data=dSmall, geom="bar")
qplot(date, unemploy, data=economics, geom="line", color='red')

# Line Chart / Timeseries
year <- function(x) as.POSIXlt(x)$year + 1900
qplot(date, unemploy, data=economics, geom="line", colour=year(date))


# Facets
qplot(carat, data=diamonds, facets=color ~ ., geom="histogram", binwidth=0.1, xlim=c(0, 3))

# Scatterplot with varied coloring
qplot(displ, hwy, data = mpg, colour = factor(cyl))







