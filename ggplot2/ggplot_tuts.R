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

# 3. Plot styling: Adjust font size, point size, color and shape. (using theme()) --------

# 3.1. Axis range, plot title, axis title, ticks and labels
# 3.1.1 Size of plot and axis titles - IMPORTANT CAVEAT
gg + ylim(c(0,60))  # removes the data that doesnt fall within the limit. So the smoothened line changes.
gg + scale_y_continuous(limits=c(0,60))  # same as ylim
gg + coord_cartesian(ylim=c(0,60))  # Considers all points and changes only visible region.

# 3.1.2 plot title and axis title
gg + theme(plot.title=element_text(size=20, lineheight=1), 
           axis.title.x=element_text(size=15, lineheight=1),  # change X-axis title size and inclination
           axis.title.y=element_text(size=15, lineheight=1))

# 3.1.3 Size of axis text and ticks
gg + theme(axis.text.x=element_text(size=20, angle=45),# change X-axis text size and inclination
           axis.ticks.x=element_blank())  # removes axis ticks in X axis

# Customised axis text
gg + scale_x_continuous(label=function(x){return(paste0("Speed is ", x, "mph"))}) + 
  scale_y_continuous(label=function(x){return(paste0("Distance is ", x, "miles"))})  


# --- Explain element_blank, element_line, element_rect and element_text

# 3.2: Point size, shape and color
# Method 1: Assigning static shape and size
gg1 <- ggplot(data=cars, aes(x=speed, y=dist)) + labs(title="Cars") + theme(plot.title=element_text(size=20))
gg1 + geom_point(shape=2, size=7, color="firebrick")

# See below link for point shapes:
# http://rstatistics.net/essentials-of-making-plots-and-graphs/#2_Adding_title_subtitle_axis_labels_and_shape_of_point_character


# Method 2: Dynamic shape based on a value or another variable.
data("diamonds")
gg_dia <- ggplot(data=diamonds, aes(x=carat, y=price)) + labs(title="Diamonds")
gg_dia + geom_point(aes(color=cut, shape=cut, size=price)) + theme(plot.title=element_text(size=20))
gg_1 <- gg_dia + geom_point(aes(color=cut, shape=cut)) + theme(plot.title=element_text(size=20))


# 3.3. Plot Background, Panel Background, Grid and Margin
# 3.3.1 Plot Background
gg_1 + theme(plot.background = element_rect(fill = 'grey'))

# 3.3.2 Panel Bckfround
gg_1 + theme(panel.background = element_rect(fill = 'grey75'))

# 3.3.3 Grid
gg_1 + theme(panel.background = element_rect(fill = 'grey75'),
             panel.grid.major = element_line(colour = "green", size=2),
             panel.grid.minor = element_line(colour = "blue"))

gg_1 + theme(panel.grid.major = element_line(colour = "firebrick", size=2),
             panel.grid.minor = element_line(colour = "steelblue"))


# 3.3.4 Margin
library(grid)
gg_1 + theme(plot.margin = unit(c(2, 2, 0, 0), "cm")) # top, right, bottom, left

# 3.4. Themes
gg_1 + theme_bw() + theme(plot.title=element_text(size=20, lineheight=1))
gg_1 + theme_bw()
gg_1 + theme_light()
gg_1 + theme_gray()
gg_1 + theme_linedraw()
gg_1 + theme_minimal()
gg_1 + theme_classic()

# More themes found in 'ggthemes'
library(ggthemes)
gg_1 + theme_calc()
gg_1 + theme_economist()
gg_1 + theme_excel()
gg_1 + theme_few()
gg_1 + theme_fivethirtyeight()
gg_1 + theme_gdocs() 
gg_1 + theme_hc()
gg_1 + theme_pander()
gg_1 + theme_solarized()
gg_1 + theme_stata()
gg_1 + theme_tufte()
gg_1 + theme_wsj()


# 3.5. Legend ------------------------------------------------------------------
# 3.5.1 Remove legend, Change legend positions
# 3.5.1.1 Legend outside plot area:
gg_1 + theme(legend.position="none")
gg_1 + theme(legend.position="right")
gg_1 + theme(legend.position="left")
gg_1 + theme(legend.position="bottom")

# 3.5.1.2 Legend inside plot area:
gg_1 + theme(legend.position=c(0.5, 0.5))  # (0, 0) is bottom left. (1, 1) is top right
gg_1 + theme(legend.justification=c(1, 0), legend.position=c(1, 0))  # places the 'anchor-point' of legend at (1, 0), where (1, 0) is bottom right of legend 

# 3.5.2 Change or Remove Legend Title and text
# 3.5.2.1 Remove legend title
gg_1 + theme(legend.title=element_blank())  # Turn off legend title

# 3.5.2.2 Size and color of legend title
gg_1 + theme(legend.title=element_text(size=15, colour="firebrick"))  # Change size and color

# 3.5.2.3 Change Legend title
gg_1 + scale_colour_discrete(name="New Legend Title!") + scale_shape_discrete(name="New Legend Title!")  # need to specify both 'scale_colour_discrete' and 'scale_shape_discrete' because, both the colour and shape of the chart symbols vary.

# 3.5.2.4 Change Legend text
# need to specify both 'scale_colour_discrete' and 'scale_shape_discrete' because, both the colour and shape of the chart symbols vary.
gg_1 + scale_colour_discrete(labels=c) + scale_shape_discrete(breaks=c("F", "G", "VG", "Pre", "I"))

# 3.5.2.5 Change Legend order and colour
gg_2 <- gg_dia + geom_point(aes(color=cut)) + theme(plot.title=element_text(size=20))

gg_2 + scale_colour_manual(values=c("#999999", "#E69F00", "#56B4E9", "#4D4D4D", "#F57670"), 
                           name="New Title",
                           breaks=c("Fair", "Good", "Very Good", "Premium", "Ideal"),
                           labels=c("F", "G", "VG", "Pre", "I"))

# 3.5.4 Modify fill color of legend box and legend background
gg_2 + theme(legend.key=element_rect(fill='steelblue'))  # box fill
gg_2 + theme(legend.background = element_rect(fill="gray90"))  # background fill


# 4. Multiple Plots ----------------------------------------------
# Facet Wrap: Visualise, how it changes for various values for one variable.
gg_dia <- ggplot(data=diamonds, aes(x=carat, y=price)) + labs(title="Diamonds") + geom_point(aes(color=cut, shape=cut)) + theme(plot.title=element_text(size=20))
gg_1 <- gg_dia + facet_wrap(~ color, ncol=3)  # scales are fixed for all plots in grid
gg_1 <- gg_dia + facet_wrap(~ color, scales="free", ncol=3)  # Allows scales roam free, so could bias the interpretation.
print(gg_1)

# Facet Grid: Visualise, how it changes for various values for TWO variables.
gg_1 <- gg_dia + facet_grid(cut ~ color)  # 'cut' will be in rows, 'color' will be in columns
print(gg_1)


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


# 10. Annotation: Display text inside the plot.
library(grid)
gg_dia <- ggplot(data=diamonds, aes(x=carat, y=price)) + labs(title="Diamonds") + geom_point(aes(color=cut, shape=cut)) + theme(plot.title=element_text(size=20))

my_grob = grobTree(textGrob("My Custom \nAnnotation!", x=0.7,  y=0.2,
                            gp=gpar(col="darkgreen", fontsize=20, fontface="bold")))

gg_dia + annotation_custom(my_grob)


# 11. Time series
# How to draw a simple time series.



# 12. Show how autoplot works?


# Grid lines

# Plot types
# - Boxplot
# - violin plot
# - jitter
# - ribbon




