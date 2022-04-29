# path and file names
data.path = "" # change for your use case
data.name = "spambase_data_csv.txt"
RDS.file.name = "RDSdata.rds"
out.file.name = "spam_base.RData"

# read through the names file and extract column names
names = c()
con = file(paste0(data.path, "spambase.names"), "r")
idx = 0
while ( TRUE ) {
  if (idx < 32) { # start reading where columns begin, ignoring comments
    idx = idx + 1
    line = readLines(con, n = 1)
    next
  } else {
  line = readLines(con, n = 1)
  name = sub("\\:.*", "", line) # split on colon : character
  names <- c(names, name)
  if ( length(line) == 0 ) {
    break
  }
 }
}
close(con)

# read the data with column names
data <- read.csv(paste0(data.path, data.name), col.names = names)

# maintain regularily for experimentation purposes with seed
set.seed(123)

# generate random fractional decimal numbers for random simulation
data$RNG <- runif(nrow(data))

# Use ifelse to create a flag splitting into test/train data with 50/50 split
data$train1 <- ifelse(data$RNG < 0.5, 1, 0)
data$test0 <- ifelse(data$RNG >= 0.5, 0, 1)

# confirm; if TRUE, the above worked OK
sum(data$train1==1) + sum(data$test0 == 0) == nrow(data)

# see the below outputs are fascinatingly ~50% each
sum(data$test0 == 0)/nrow(data)
sum(data$train1==1)/nrow(data)

# Save the processed data set as an .RData object. 
saveRDS(object = data, file = paste0(data.path, RDS.file.name))

# Read the .RData object back into R and check that it is correct.
rds <- readRDS(paste0(data.path, RDS.file.name))

# Write out the processed data file; 
out.file <- paste(data.path, out.file.name, sep='')

