# WFA Database Normalization

# Built in R Version 3.4.3
# Built in RStudio Version 1.1.414

# Set WD, Load Packages, Read-In Data

setwd( "~/ProLiteracy/Normalization" )

library( zoo )
library( purrr )
library( tidyr )
library( dplyr )
library( readr )
library( stringr )

context <- read.csv("context.csv")

# Remove NA Rows

context <- context[ c( 1 , 3:nrow( context )) , ]
context <- context[ c(1:44 , 46:nrow( context )) , ]

# Remove ":" from Titles

context$orig_context <- gsub(x = context$orig_context , pattern = ":" , replacement = "" )
context$new_context <- gsub(x = context$new_context , pattern = ":" , replacement = "" )

# Reduce Variables

context <- context %>%
  select( orig_context ,
          new_context ,
          context_descript )

# Create "Category" Indicator Column

context$cat <- NA

for ( x in 1:nrow( context )){
  if ( grepl( x = context$orig_context[x] , 
              pattern = "\\(.*\\)") ){
    context$cat[x] <- 1
  } else {
    context$cat[x] <- 0
  }
}

rm( x )

# Remove Number of Elements in Category Headers

context$orig_context <- str_replace_all( string = context$orig_context , 
                                         pattern = "\\(.*\\)" , 
                                         replacement = "" )

# Convert Class Types

context$context_descript <- as.character( context$context_descript )
context$cat <- as.factor( context$cat )

# Import Original Context Data & Match Unique Context ID Keys

orig <- read.csv( "context_orig.csv" )

orig <- orig[ c( 3:4 )] %>% 
  unique()

colnames( orig ) <- c( "id" , 
                       "orig_context" )

orig$id <- as.character( orig$id )
orig$orig_context <- as.character( orig$orig_context )

context <- left_join( context , orig )

rm( orig )

# Rearrange Variables

context <- context %>%
  select( orig_context ,
          id ,
          cat ,
          new_context ,
          context_descript )

# Minor Adjustment

context[ 44 , "context_descript" ] <- "How often do you work when it's very hot or very cold?"

# Write to .csv

setwd( "~/ProLiteracy/Normalization/Prepared" )

write.csv( context , "context_final.csv" )
