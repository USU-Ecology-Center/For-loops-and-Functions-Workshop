### USU Ecology Center workshops: Loops and apply()

# Led by Annie Schiffer
# Adapted from Courtney Check's and Brian Smith's Loops and Functions workshop
# Adapted from Dani Berger's apply workshop

### Outline ------------

# 1. Loops and apply: what they are and when to use them
# 2. Quick review of indexing
# 3. Basic loops
# 4. Apply()
# 5. Variations of apply()
# 6. More advanced: nested loops

### 1. Loops and apply: what they are and when to use them ------------

# FOR LOOP

# A for loop is a function in R that iteratively execute lines of code over a set of inputs. 
# It's basically the same as copying and pasting the same code for multiple inputs.
# With loops, you can repeatedly run code for each input, then store it in an output object.

# One thing to consider: the more loops you add, the slower your R will run because each iteration takes up memory in R. 
# They're most useful for repeated or compounding calculations 
# (e.g. population size over a bunch of years, and population depends on previous year).

# APPLY()

# The apply function similarly performs some operation over a set of inputs, but it's not iterative.
# In other words, it also is the same as copying and pasting the same code for multiple inputs, 
# but it does it all at once, instead of one input at a time.
# This makes it faster than a loop, but inputs have to be independent.
# Apply is most useful for performing a calculation or running code over a large number of inputs.


# WHY BUILD LOOPS OR USE APPLY WHEN YOU CAN COPY AND PASTE?

# Loops and apply are less prone to errors than copying and pasting.
# They make your code more readable, while copying and pasting can make your scripts long and messy.


### 2. Quick review of indexing --------------------------

# Indexing is essential for loops because your inputs are stored in a vector, 
# and then the loop iteratively grabs each element in the vector by its index. 
# Your outputs also need to be indexed.

# a few quick ways to make a vector:
vector1 <- c(3, 50, 42, 21) # the combine function
vector2 <- seq(from = 3,to = 4.5, by = 0.5) # the sequence function

# use the brackets to pull out certain elements in a vector
vector1[2] # second element of vector 1

# With a 2 dimensional object (like a matrix or data frame), use a "," to index rows or columns
my.df <- data.frame(cbind(vector1,vector2))
my.df

my.df[1,2] # element in 1st row, 2nd column


### 3. Basic loops -------------------------------------------

## KEY COMPONENTS OF A LOOP:

# - a vector to loop over (the lines of code are executed with each element of the vector)
# - an empty output object
# - a "for" statement that loops over the vector: "for(i in 1:length(x))"
# - indexed inputs and outputs

## Input vector to loop over
inputs <- seq(from = 40, to = 70, by = 5)
inputs

## Output vector to store our changes

# We have to create an empty output vector that is the same length as our inputs.
# I like to use a vector of NAs so I can make sure my output vector is the length I want it to be. 
# You can also just make this an empty vector using vector().

outputs<-rep(NA,length(inputs))

# In our loop, let's add 2 to each element of our inputs vector. 
# We have to index the inputs AND the outputs.

for(i in 1:length(inputs)){
  
  outputs[i] <- inputs[i] + 2
  
}
outputs
# The loop grabbed each element of the inputs vector, added 2 to it, then stored it in the same index of the outputs vector.
# You can also use "seq_along" instead of 1:length(vector).

## Loops are most useful if your output depends on a previous index.
# For example, let's say we want to model population size over time.

# Input - time steps
time <- 1:100

# Output - population size over time
# We have to add a starting value if we want outputs to depend on previous index
pop <- c(20,rep(NA,99))

# We'll loop over time from year 2, since we already know the population in the first year.
for(i in 2:max(time)){
  
  pop[i] <- pop[i-1] * runif(1,min=0.5,max=1.5) # just getting a random number to represent the population growing or shrinking
  
}

plot(pop ~ time,type="l",xlab="Year",ylab="Population size",main="Population size over 100 years")


# COMMON MISTAKES WHEN LEARNING LOOPS

# It's super easy to forget to index or store the output (I still do it all the time).
# What happens if we don't tell it to print an output object?
for(i in 1:length(inputs)){
  
  inputs[i] + 2
  
}
# The loop runs but we don't see any output.

# What happens if we have an output object but forget to index it?
for(i in 1:length(inputs)){
  
  outputs <- inputs[i] + 2
  
}
outputs
# The loop runs, it assigned the changes in "outputs"
# but only the last iteration (i) is stored because each iteration is overwritten.

### Your turn!

# Loop over the following input vector: 4,6,2,4,9,10. In the loop, multiply the input by 6.5.
# Store the results in an output vector. Feel free to check your answer with AI.








### 4. Apply() function --------------------------

# Inputs of apply() can be a matrix or array. 
# The formatting of outputs depends on the input and the function applied to the data.

# COMPONENTS OF THE APPLY() FUNCTION

# The apply() function takes three arguments: apply(X, MARGIN, FUN)

# - X: the input object (data.frame, matrix, or array)
# - MARGIN: the dimension of the data object over which the function is applied. 1 = row-wise, 2 = column-wise, c(1,2) = rows and columns
# - FUN: a built-in or custom function to apply to the input data

# Create an example matrix
ex_matrix <- matrix((1:12), nrow = 3)
print(ex_matrix)

# Let's get the mean of every row
row_mean <- apply(ex_matrix, 1, mean) # MARGIN: 1 applies the function to rows

row_mean

# The output is a vector with the mean of the numbers in each row.
# So even though we started out with a matrix, the function determined that our output would just be a vector

# Now I'm going to create my own function called square.
square <- function(x){x^2}

# I use the square function within my apply function. 
all_square <- apply(ex_matrix, c(1,2), square) # MARGIN = c(1,2) returns all values

all_square

# The output is a matrix with each value in my input matrix squared.

# Your turn!
# Sum each column of the example matrix.







### 5. Variations of apply() -------------------------

# LAPPLY()

# lapply() function is one variation of the general apply() function.
# It takes a vector, list, or data.frame as an input and always returns a list. 
# The "l" prefix stands for list. The MARGIN argument isn't relevant here because we're working with lists.

# Create an example list
ex_list <- list(ex_matrix, c(1,2,3), 20) # lists can have any data type!

ex_list

# Write a function that adds one to each element
add_one <- function(x){x+1}

# Apply the function to the example list
list_add_one <- lapply(ex_list, add_one)

list_add_one

# SAPPLY()

# sapply() function is a simplified form of the lapply() function.
# The sapply() function takes a vector, list, or data frame as inputs.
# It usually returns a vector or a matrix, sometimes a list if it can't be a vector or matrix.
# "s" in the function name stands for "simplified." Again the MARGIN argument isn't relevant here because it can use lists.

# will return a SIMPLIFIED version when possible
list_sum_l <- lapply(ex_list,sum)
list_sum_l # returns list

list_sum_s <- sapply(ex_list,sum)
list_sum_s # returns vector

# works with vectors, unlike apply or lapply
ex_vec <- seq(from = 40, to = 70, by = 5)
vec_add_one <- sapply(ex_vec, add_one)
vec_add_one


# Your turn! 
# Use sapply or lapply to subtract 1 from each element of the list "ex_list."








### 6. More advanced: nested loops ----------------

# Sometimes you want to increase efficiency by looping over multiple things at once.
# You can write a loop inside another loop, but you must use a different character to index. 
# For example, I used "i" in the loops above, but you can use any character string you want to index. 
# If I have several nested loops, it helps me to make these indices intuitive (e.g. "iSpecies" or "iSite").

# STRUCTURE OF NESTED LOOP

# Create output matrix with rows and columns, let's do 10 rows and 3 columns as an example
my.matrix <- matrix(NA, nrow = 10, ncol = 3)
my.matrix

# Here's a demonstration of how the loop will work
for (irow in 1:nrow(my.matrix)){
  for (icol in 1:ncol(my.matrix)) {
    
    my.matrix[irow,icol] <- paste0(irow,",",icol)
    print(paste0("completed row ", irow," and column ",icol))
    
  }
}
my.matrix


# NESTED LOOP EXAMPLE

# Let's say we have 3 species that we observe over 10 years. Their populations all grow at the same rate but different starting sizes.

# Create input vectors
species <- 1:3
years <- 1:10

# Create output matrix - we want the populations sizes of 3 species over 10 years. Let's do years in rows, species in columns.
out.mat <- matrix(data=NA,nrow=length(years),ncol=length(species))
out.mat

# All have different starting sizes in year (row) 1
init_sizes <- c(4,18,30)
out.mat[1,] <- init_sizes
out.mat

# We know population sizes at year 1, so loop starts at year 2. All grow at population growth rate of 1.4.
for (iyear in 2:length(years)){ 
  for (isp in 1:length(species)) {
    
    out.mat[iyear, isp] <-  out.mat[iyear-1,isp] * 1.4
    
  }
}

# Check the results
out.mat

