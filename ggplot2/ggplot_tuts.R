# ggplot2
library(ggplot2)
library(ggfortify)

# 1. Basic plot
# Plot a scatterplot from cars data
# Draw a line of best-fit using 3 differnt functions. add smoothing conf-intervals layer.

# 2. Plot Elements
# Assign title, x-axis and y-axis labels, x-axis and y-axis text

# 3. Plot styling
# Adjust title's font and size, point size, color and shape. (using theme())

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




