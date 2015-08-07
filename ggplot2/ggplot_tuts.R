# ggplot2
library(ggplot2)
library(ggfortify)

# Questions answered:
# 1. what is the underlying structure to making plots using ggplot?
# 1.1 How is ggplot different from base graphics? What are the pros and cons?
# Cons: - You need to type in more text compared to base graphics to create 
#       even  simple plots.
#       - Since it has its own grammer and because there are more facilities, 
#         it takes more time to learn.
# Pros: - Looks great. Nice soothing colours, great grid lines, customised themes etc.
#       - When your graph becomes more complex, it is much easier to acheive
#         complex graphics compared to based graphics, especially becasue of the
#         ability to create muliple layers, faceting etc. 

# 2. How to make different types of plots with ggplot?
# 3. How to add and modify the various elements of a plot in ggplot?


############################
library(ggplot2)

# 1. Basic plot
# Plot a scatterplot from cars data
# Draw a line of best-fit using 3 differnt functions. add smoothing conf-intervals layer.

ggplot(data=cars, aes(x=speed, y=dist)) + geom_point()

# (or)

gg <- ggplot(data=cars, aes(x=speed, y=dist))
gg + geom_point()

# (or)

gg <- ggplot(data=cars, aes(x=speed, y=dist)) + geom_point()
print(gg)

# 1.1 Add a smoothing line
ggplot(data=cars, aes(x=speed, y=dist)) + geom_point() + geom_smooth()  # default method is 'auto'
ggplot(data=cars, aes(x=speed, y=dist)) + geom_point() + geom_smooth(stat ="identity") # connecting lines
ggplot(data=cars, aes(x=speed, y=dist)) + geom_point() + geom_smooth(method="lm") # method can take: 'lm', 'loess', 'gam'

ggplot(data=cars, aes(x=speed, y=dist)) + geom_point() + stat_smooth()  # alternate method

# 1.2 Save a plot
# Method 1:
ggsave(file="c:/Users/XUZ48472/Desktop/myplot.png")  # saves plot show in plotting panel.
ggsave(a, file="c:/Users/XUZ48472/Desktop/myplot.png")  # Default: will save in same height/widht proportion as seen in plot window. 
# Also, ggsave can adjust height,  width, dpi etc

# Method 2:
png("c:/Users/XUZ48472/Desktop/myplot.png")
print(a)
dev.off()



# 2. Plot Elements -------------------------------------------------------------
# Assign title, x-axis and y-axis labels, x-axis and y-axis text

# Method 1: Assign each with dedicated command
ggplot(data=cars, aes(x=speed, y=dist)) + geom_point() + geom_smooth() + ggtitle("Cars")
ggplot(data=cars, aes(x=speed, y=dist)) + geom_point() + geom_smooth() + xlab("Car: speed")
ggplot(data=cars, aes(x=speed, y=dist)) + geom_point() + geom_smooth() + ylab("Car: dist")
ggplot(data=cars, aes(x=speed, y=dist)) + geom_point() + geom_smooth() + ggtitle("Cars") + xlab("Car: speed") + ylab("Car: dist")

# Method 2: Assign all with one command
gg <- ggplot(data=cars, aes(x=speed, y=dist, size=dist)) + geom_point() + geom_smooth() + labs(title="Cars", x="Car:Speed", y="Car:dist")
print(gg)

# 3. Plot styling --------------------------------------------------------------
# Adjust title's font size, point size, color and shape. (using theme())
# 3.1. Title, X and Y axis labels
gg + theme(plot.title=element_text(size=30, lineheight=1),
           axis.title.x=element_text(size=20, lineheight=1),
           axis.title.y=element_text(size=20, lineheight=1))

# --- Explain element_blank, element_line, element_rect and element_text

# 3.2: Point size and shape
# Method 1: Assigning static shape and size
gg1 <- ggplot(data=cars, aes(x=speed, y=dist)) + labs(title="Cars") + theme(plot.title=element_text(size=20))
gg1 + geom_point(shape=2, size=7)

# See below link for point shapes:
# http://rstatistics.net/essentials-of-making-plots-and-graphs/#2_Adding_title_subtitle_axis_labels_and_shape_of_point_character


# Method 2: Dynamic shape based on a value or another variable.
data("diamonds")
gg_dia <- ggplot(data=diamonds, aes(x=carat, y=price)) + labs(title="Diamonds")
gg_dia + geom_point(aes(color=cut, shape=cut)) + theme(plot.title=element_text(size=20))

# 3.3. Other Axis Attributes: Axis.line, axis.text,  

# 3.4. Panel Background
gg1 + geom_point() + theme_bw()


# 4. Legend

# 4.1. Legend position, background, Key, Text, Title. See ?theme examples

# 4.2. Change legend title.




# 4. Limit range of x and y axis.
# limit an axis to a range (using g + ylim(c(0,60)) or g+scale_x_continuous(limits=c(0,35)) 
# or g+coord_cartesian(xlim=c(0,35)). The former removes all data points outside the range and second adjusts the visible area.)


# 5. Adding custom X and Y axis labels. 
# How to add custom labels in X and Y axis? 
#   ggplot(nmmaps, aes(date, temp))+
#   geom_point(color="grey")+
#   labs(x="Month", y="Temp")+
#   scale_y_continuous(label=function(x){return(paste("My value is", x, "degrees"))})

# 6. Legend
# How to turn off legend? Ans: g+theme(legend.title=element_blank())
# Adjust legend, size, color. Ans: g+theme(legend.title = element_text(colour="chocolate", size=16, face="bold"))
# Change title of legend. Ans: scale_color_discrete(name="This color is\ncalled chocolate!?")
# Change position of legend


# 7. Panel background, Grid lines and Margin
# How to change color of panel background? Ans: theme(panel.background = element_rect(fill = 'grey75'))
# How to change the major and minor gridlines? Ans: theme(panel.background = element_rect(fill = 'grey75'), panel.grid.major = element_line(colour = "orange", size=2),
#                                                   panel.grid.minor = element_line(colour = "blue"))
# 
# How to change a plot's margin? Ans: theme(plot.background=element_rect(fill="darkseagreen"), plot.margin = unit(c(1, 6, 1, 6), "cm")) #top, right, bottom, left

# 8. Add Themes
# Adjust theme. Ans: ggthemes()

# 9. Layout Multiple plots
# Show how to use facets wrap feature. 
#  - How to arrange the number of rows and columns. Ans: + facet_wrap(row~columns, nrow=3, ncol=2)
#  - Allow scales to roam free. Ans: + facet_wrap(row~columns, nrow=3, ncol=2, scales="free")
# How to show unrelated charts in one frame? 
#   Ans: 
#   library(gridExtra)
#   myplot1<-ggplot(nmmaps, aes(date, temp))+geom_point(color="firebrick")
#   myplot2<-ggplot(nmmaps, aes(temp, o3))+geom_point(color="olivedrab")
#   grid.arrange(myplot1, myplot2, ncol=2)


# 10. Annotation


# 11. Time series
# How to draw a simple time series.



# 12. Show how autoplot works?


# Grid lines

# Plot types
# - Boxplot
# - violin plot
# - jitter
# - ribbon




