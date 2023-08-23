#######################################################X
#--------------USU Ecology Center Workshop-------------X
#--------------------For-loops and Functions-----------X
#-----------------------2023-08-23---------------------X
#--------------------Courtney Check--------------------X
#######################################################X

# Adapted from a Workshop by: 
# Brian J. Smith
# PhD Candidate, Ecology
# Department of Wildland Resources
# brian.smith@usu.edu

### Iteration ----
# Why iterate instead of copying and pasting?
#   1. Less error prone. (Human brains will not be as good at catching minute differences compared to a computer.)
#   2. More readable
#   3. Potentially more efficient

## Iteration in R: 

# R is vectorized: 
#   -There is no data of type ‘zero’ 
#   -If you create a vector of 100 numbers, we have an object of length 100, and each element of the vector is labeled 1-100. 
#   So if we add 1 to this vector, we can add 1 to each element of that vector. This seems intuitive if R is your first coding language, 
#   but it actually isn’t! But what it means is that we can loop over these elements from 1-100.

###  Basic for loop ----
## Start with a vector of length 100
v <- 101:200

## Create a basic loop to print v

for (i in 1:length(v)) {
  print(v[i])
}

# When specifying the "i in 1:length(v)" —> it is looping over each element one at a time; 
# length() refers specifically to vectors, while nrow() is the equivalent function for dataframes.
# You can set i and look at it in the environment!

## Try setting i

i <- 3
print(v[i])

# Now let's create a basic loop.

## Loop over all elements of v and add 1
for (i in 1:length(v)) {
  v[i] + 1
}

# Why don't we see the addition?
# Normally if you write something in the console, R assumes you want to print it, but in a function the rules change. 
# So you have to be sure you tell R explicitly what you want it to do (you want it to print in this case).

for (i in 1:length(v)) {
  v[i] + 1
  print(v[i])
}

# BUT if run it with print, still nothing happened. The computation didn’t save. 
# So it printed it, it did the computation, but it didn’t save because we didn’t store it.
# Let's try storing the output as 'w'. What length will the 'w' vector be?

for (i in 1:length(v)) {
  w <- v[i] + 1
}

# It was length 1! That's because w is being overwritten for each value of i. It overwrote 100 times and didn't save the data. 
# We need to say in the ‘ith’ slot of w, to put the relevant value.
# (Note: You don’t always have to save w. If you want to overwrite it every time as a temporary variable in a calc, that is fine)

for (i in 1:length(v)) {
  w[i] <- v[i] + 1
}

# But w isn’t found! Why didn't we get this error before? —> As a high level language, R is good at defining things on the fly 
# (like a new variable such as w). But if w doesn’t exist, it doesn’t know how to access the ‘ith’ element of w.
# So we have to ‘initialize; first —> this is almost the only time in R that you have to define things first.

## Initialize a vector to hold the output
w <- numeric()

for (i in 1:length(v)) {
  w[i] <- v[i] + 1
}

## Check to see if it worked
cbind(v, w)

### Basic while loop ----
# For loops are great when you know ahead of time how many
# times you want to iterate.

# If you need to keep iterating until a condition is met --
# no matter how long it takes -- use a while loop.

## Let's generate random integers between 1 and 10
# E.g., 
round(runif(n = 1, min = 1, max = 10))

# Let's say we want to generate a vector that adds up to 
# at least 100.

## Initialize a vector to hold the results
hundo <- numeric()

while (sum(hundo) < 100) {
  # Figure out how long hundo is
  l <- length(hundo)
  # Add a random number to hundo[l + 1]
  hundo[l + 1] <- round(runif(n = 1, min = 1, max = 10))
}

## How many iterations did it take?
length(hundo)

## What does it sum to?
sum(hundo)

### Nested for loop ----

# Sometimes, a variable has 2 indices on it (for example, i sites and j survey times). 
# And you want to see if your animal is there on each site and survey. When this happens, 
# your data is like a matrix because it has more than one index. When there are 
# more than one indices, you can nest you for loops

# Generate a matrix of 0s and 1s
# E.g., this could be site occupancy data
# Disclaimer: not simulating from an actual occupancy process

# 10 sites (index with "i")
# 3 survey occasions (index with "j")

## Initialize a matrix
sites <- matrix(NA, nrow = 10, ncol = 3)

## Here's a demonstration of how the loop will work
for (i in 1:nrow(sites)){
  # Print status
  print(paste("Working on site number", i))
  for (j in 1:ncol(sites)) {
    print(paste(i, j))
  }
  # Print status
  print(paste("Done."))
}

## Fill in 1s and 0s
for (i in 1:nrow(sites)){
  # Print status
  print(paste("Working on site number", i))
  for (j in 1:ncol(sites)) {
    sites[i, j] <- rbinom(n = 1, size = 1, prob = 0.5)
  }
  # Print status
  print(paste("Done."))
}

## Check the results
sites

### Working with files ----

# Say we have a bunch of GPS data from 10 different animals
# stored as 10 different files.

# I want to demonstrate reading them all in, but first we 
# need to generate the sample data.

# (Note, this first for loop is not too important to understand,
# we just want to make up some sample data. Try to focus on how
# to use the data, not how to simulate it.)

## Say we have a folder in our working directory where we keep
# all of our GPS data.
dir.create("GPS")

## Now let's create 10 animal IDs
animals <- paste0("Anim", 1:10)

## Loop over each animal and generate some data for that
# animal
for (i in 1:length(animals)) {
  
  # Create data.frame with randomly generated data
  d <- data.frame(ID = animals[i],
                  # Longitude
                  x = -1 * runif(10, min = 111.0, max = 111.5),
                  # Latitude
                  y = runif(10, 39, 39.5),
                  # Date
                  t = Sys.Date() + (1:10))
  
  # Save data.frame to disk
  write.csv(d, 
            paste0("GPS/", animals[i], "_data.csv"), 
            row.names = FALSE)
}

# Now, how do we load this data in?

# (This is the part you should focus on!)

## First, figure out the filenames.
files <- list.files("GPS", full.names = TRUE)

## Loop over the files, load each one in, and add it to
# a master data.frame

## Initialize an empty data.frame
my_data <- data.frame()

## Loop over all the elements of (the vector) 'files'
for (i in 1:length(files)) {
  # Load the i-th file
  f <- read.csv(files[i])
  
  # Append to 'my_data'
  my_data <- rbind(my_data, f)
}

# Note: this is scaleable. If I collect more data every year to add to this folder, 
# I can do the same thing without changing my code at all bc it will always get 
# the length right

### Loop over list elements ----

# Lists are the most flexible data type in R. They are just an ordered 
# collection of objects. (Vs a vector: which is a list of only one data type. 
# VS a dataframe, which is just a collection of vectors as columns, all of 
# which must be the same length.)

# Load in our GPS data again, but instead of loading to a 
# master data.frame, load each data.frame as the element
# of a list. We may want to do this if our dataframes all have different lengths,
# for example.

## Initialize the list
data_list <- list()

# #Loop over all of our files, and load each data.frame

for (i in 1:length(files)) {
  data_list[[i]] <- read.csv(files[i])
}

## Get the data for the 4th animal
data_list[[4]]

### Lapply and friends ----

# Because R is a very high level programming language, running for-loops is not 
# always the most efficient way to do things. In fact, some people say if your 
# writing a for-loop in R you’re wrong, that’s maybe overkill. Because in R, 
# for-loops basically take up a lot of memory. And so each iteration of the loop 
# will get slower. But lists take up a lot less memory. So using apply 
# (which is used for running functions over each element of a list) can be really useful 
# Knowing that lapply exists is mental scaffolding for solving more complex problems.
# Almost anything you can do with a for loop, you can do with an apply.

### Basic lapply ----
# The leading "l" in "lapply" means "list".
# lapply takes a list as an input and returns a list as an output.
# The function takes the input and uses it to create the output.

## How many rows of data do we have for each animal?
lapply(data_list, nrow)

# If you want the result back as a vector, you can use the
# function 'unlist()'. Be warned that 'unlist()' is recursive
# by default, and so will take apart your data.frames and other
# lists in (possibly) unexpected ways. Works well here to return
# a vector:

unlist(lapply(data_list, nrow))

## Maybe combine with animal IDs
data.frame(ID = animals, 
           data_points = unlist(lapply(data_list, nrow)))

### Sapply ----
# This "simplifies", which is (in this case) doing the
# unlist part for you. Basically, does same thing as lapply, but simplifies it. 
# It takes down to the simplest form it can —> in this case, it does the enlisting for us
sapply(data_list, nrow)

### Writing custom functions ----
# Writing your own functions is very useful in general. We'll take
# a quick look at writing custom functions here, then focus on
# using our custom functions in an lapply.

### A basic function ----
# Functions have a name and are declared like any other
# object in R

# Syntax:
# <name>(<argument 1>, <argument 2>, <etc>) {
#     # WHATEVER YOU WANT IT TO DO
# }

## Function with 1 argument
## Write a function that adds 1 to a number
add1 <- function(x) {
  y <- x + 1
  return(y)
}

# In functions, the rules change. You have to specify what, if any, 
# data that you want to function to spit out using 'return.' If you don't,
# then the function will run but give no output. 

## Use our function
add1(x = 3)
add1(5)

## Write a function with 2 arguments
add_n <- function(x, n) {
  y <- x + n
  return(y)
}

add_n(x = 6, n = 2)
add_n(3, 5)

## Function with 0 arguments
rand_integer <- function() {
  return(round(runif(n = 1, min = 1, max = 10)))
}

rand_integer()
rand_integer()
rand_integer()

# Functions aren't limited to arithmetic or numeric manipulation.
# E.g., you can write a custom function that manipulates a 
# particular data.frame.

## Write a function that returns our animal ID from one
# of our GPS data.frames
anim_id <- function(df) {
  id_col <- df$ID
  id <- unique(id_col)
  return(id)
}

anim_id(data_list[[1]])
anim_id(data_list[[5]])

### Using custom functions in lapply ----
## Now let's get the animal ID for all animals in our data list
lapply(data_list, anim_id)

## We can get this as a vector with 'unlist()'
unlist(lapply(data_list, anim_id))

## We can also get this as a vector with 'sapply()'
sapply(data_list, anim_id)

### Writing functions on the fly ----
# We don't necessarily have to write our functions ahead of time.
# We can write a function within an 'lapply()' (or anywhere that
# we need a function).

## Let's get the centroid of each animal's location
# I.e., mean(x-coord) and the mean(y-coord)
lapply(data_list, function(df) {
  cent_x <- mean(df$x)
  cent_y <- mean(df$y)
  return(c(cent_x, cent_y))
})

## We can let 'sapply()' simplify this to a matrix for us
sapply(data_list, function(df) {
  cent_x <- mean(df$x)
  cent_y <- mean(df$y)
  return(c(cent_x, cent_y))
})
# Note each column came from a list element and the rows are the
# x-coordinate and y-coordinate.

## If we want to transpose that matrix (i.e., we want each row to
# come from a list element and the columns to be the coordinates)
# then we can just use 't()' to transpose.

t(sapply(data_list, function(df) {
  cent_x <- mean(df$x)
  cent_y <- mean(df$y)
  return(c(cent_x, cent_y))
}))

## Splitting Dataframes and rejoining them
# Splitting dataframes can be useful for running a function over distinct chunks of data. 
# For example, several different animal ids.
split.animals = split(my_data, my_data$ID)

library(tidyverse)
join.animals = bind_rows(split.animals, .id = "ID")

### OPTIONAL: Now demonstrate on a more complicated script from the instructor's research! 
# Show a case when you used for-loops and/or functions in your research so people 
# can see the application of these concepts. Then, ask for questions from folks if 
# they want to know how this could apply to their own research



