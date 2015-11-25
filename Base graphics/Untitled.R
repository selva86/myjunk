# Make a complete plot - Part 1
# Making a complete R plot with base graphics is a 3 part series, that starts 
# with a minimal R plot and progressively extend it to make a full featured R plot - with
# all features such as: plot title, axis labels, axis limits, change point character, add a line
# of best fit, grid, box, legend, annotation, margin text, num of plot panels (mfrow) and 
# finaly saving the plot.

# Make a complete plot - Part 1 ------------------ 
#1. How to make a simple R plot? Explain how R automatically makes the X axis.
plot(1:10)

#2. How to make a basic scatterplot, what are the bare minimal args needed? how to specify them?
plot(x=cars$speed, y=cars$dist)

#3. How to add title, sub title, axis labels, axis limits and change point character ?
# Every thing can be changed by modifying an argument of the plot() function. Interestingly, 
# the complete set of arguments for the plot function are located in the help file of the 
# par() function
# plot’s main title: main
# plot’s sub title: sub
# x axis title: xlab
# y axis title: ylab
# plot character(symbol): pch
plot(x=cars$speed, y=cars$dist, main="Dist vs Speed", sub="from the 'cars' dataset", 
     xlab="Speed", ylab="Dist", xlim=range(cars$speed), ylim=range(cars$dist), pch='*') 

  # Show how to zoom in into the plot by modifying the range.
plot(x=cars$speed, y=cars$dist, main="Dist vs Speed", sub="from the 'cars' dataset", 
     xlab="Speed", ylab="Dist", xlim=c(10, 20), ylim=c(20, 80), pch='*') 

#####################################################################
# Make a complete plot - Part 2 -------------------------------------- 

#4. How to change the colors?
# color of symbols: col
# color of main title: col.main
# color of x and y axes: col.axis
# color of axis labels: col.lab
# color of subtitle: col.sub
# color of chart background: bg
plot(x=cars$speed, y=cars$dist, main="Dist vs Speed", sub="from the 'cars' dataset", 
     xlab="Speed", ylab="Dist", pch='*', col="blue", col.main="red", col.axis="orange", 
     col.lab="darkgreen", col.sub="grey")

#5. How to change the size ?
# size of symbols: cex
# size of main title: cex.main
# size of x and y axes: cex.axis
# size of axis labels: cex.lab
# size of subtitle: cex.sub
plot(x=cars$speed, y=cars$dist, main="Dist vs Speed", sub="from the 'cars' dataset", 
     xlab="Speed", ylab="Dist", pch='*', col="blue", col.main="red", col.axis="orange", 
     col.lab="darkgreen", col.sub="grey", cex=1.5, cex.main=1.5 , cex.axis=1.5, 
     cex.lab=1.5, cex.sub=1.5)

#6. How to plot multiple plot in one panel.
par(mfrow=c(2, 2)); 
plot(1:10, main="1")
plot(1:10, main="2")
plot(1:10, main="3")
plot(1:10, main="4")

########################################################################
# Make a complete plot - Part 3 --------------------------------------

#7. How to turn off axes, add line of best fit, grid and box ?
plot(x=cars$speed, y=cars$dist, main="Dist vs Speed", sub="from the 'cars' dataset", xlab="Speed", ylab="Dist", pch='*', col="blue", axes=FALSE) # turn off plotting axes
abline(lm(dist ~ speed, data=cars), lwd=5) # line of best fit
grid(10, lty=1, col="red") # add grid
box(col="red", lwd=3, lty=1) # draw a box around the graph.

#8. How to add and modify legend?
# Legend can be added by calling the legend() function after drawing the plot. The plot should be 
# displaying on the panel with legend() is called. Everything about legend can be controlled from within the arguments of legend function.
#  - location on plot goes as the first argument. This could be a x and y co-ordinated or one of the following: “bottomright”, “bottom”, “bottomleft”, “left”, “topleft”, “top”, “topright”, “right” and “center”.
#  - distance from axis as a fraction of plot area: inset
#  - title of legend: title
#  - legend text: legend. This there are more than one text, they can be passed as a character vector.
#  - what color to fill in: fill. If multiple colors are to be specified, they can be arranged in desired order and passed as a vector.
#  - place the legend horizontally or not: horiz
legend("bottomright", inset=.01, title="Distance vs Speed", legend=c("dist and speed"), fill="blue", horiz=TRUE)

#9 How to add text in the margin and test inside the plot ?

# -- TEXT ON THE MARGIN.
plot(1:10, 1:10, main = "Sample plot to demonstrate margin text") # main plot
# 1=bottom, 2=left, 3=top, 4=right.
mtext("margin text at bottom", side=1, col=1) # bottom margin text
mtext("margin text at left", side=2, col=2)
mtext("margin text at top", side=3, col=3)
mtext("margin text at right", side=4, col=4)

#  -- TEXT INSIDE PLOT
plot(1:10, 1:10, main = "text(...) examples\n~~~~~~~~~~~~~~")
points(c(6,2), c(2,1), pch = 3, cex = 4, col = "red") # add two red +'s
text(6, 2, "the text is CENTERED around (x,y) = (6,2) by default", cex = .8) # text at (6,2)
text(2, 1, "or Left/Bottom - JUSTIFIED at (2,1) by 'adj = c(0,0)'", adj = c(0,0), cex=0.8) # text at (2,1), with hinge point of text moved to 0,0 so the text doesn't disappear off the plot
text(x=(1:10)-0.25, y=1:10, 1:10, col=1:10) # add numbers as text near the points


#10. How to save plot to file
# Call the png() function, draw the plot and then do a dev.off()
png("path/to/fileDir/imagefilename.png", height=300, width=300) # plot will be saved to this file
plot(1:10) # draw the plot
dev.off() # turn off device