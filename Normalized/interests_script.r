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

interests <- read.csv( "interests.csv" )

# Rename Columns & Reduce

colnames( interests )[6] <- "new_interest_descript"
interests <- interests %>%
  select( orig_interest ,
          new_interest ,
          new_interest_descript )

# Reduce Rows

interests <- interests[ c( 1 , 3 , 5:7 , 10 ) , ]
rownames( interests ) <- 1:6

# Read In "Original Interests" Data

orig <- read.csv( "interests_orig.csv" ) %>%
  select( Element.ID , Element.Name )

orig <- unique( orig )[1:6 , ]

colnames( orig ) <- c( "id" ,
                       "orig_interest" )

# Convert Classes

for ( x in 1:ncol( orig ) ){
  orig[ , x ] <- as.character( orig[ , x ] ) }

for ( x in 1:ncol( interests ) ){
  interests[ , x ] <- as.character( interests[ , x ] ) }

rm( x )

# Merge Identifiers on "Interest" Title

interests <- left_join( orig , interests )

rm( orig )

# Write to .csv

setwd( "~/ProLiteracy/Normalization/Prepared" )

write.csv( interests , "interests_final.csv" )

