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

skills <- read.csv( "skills.csv" ) %>%
  select( orig_skill ,
          new_skill ,
          new_skill_descript )
orig <- read.csv( "skills_orig.csv" ) %>%
  select( Element.ID ,
          Element.Name ,
          Scale.ID ,
          Scale.Name )

# Convert Blank Cells to NA Values & Reduce Rows

skills[ skills == "" | skills == " " ] <- NA
skills <- skills [ complete.cases( skills ) , ]

# Remove Colon (:) from Titles

for ( x in 1:ncol( skills )){
  skills[ , x ] <- str_replace_all( string = skills[ , x ] , 
                                    pattern = ":" , 
                                    replacement = "") }

rm( x )

# Minor Content Fix (Category Parantheses)

skills$new_skill <- str_replace( string = skills$new_skill , 
                                 pattern = "s\\(4" , 
                                 replacement = "s \\(4" )

# Create "cat" Variable for Slill Categories

skills$cat <- NA

for ( x in 1:nrow( skills )){
  if ( grepl( x = skills$orig_skill[x] , 
              pattern = "\\(.*\\)") ){
    skills$cat[x] <- 1
  } else {
    skills$cat[x] <- 0
  }
}

rm( x )

# Remove "Category" Quantities in Parentheses

skills$orig_skill <- str_replace_all( string = skills$orig_skill , 
                                         pattern = "\\(.*\\)" , 
                                         replacement = "" )
skills$new_skill <- str_replace_all( string = skills$new_skill , 
                                         pattern = "\\(.*\\)" , 
                                         replacement = "" )

# Rename Row Names & Convert Classes

rownames( skills ) <- 1:nrow( skills )

skills$cat <- as.factor( skills$cat )

# Rename Original Skills Data, Check Classes, Reduce to Unique Values

colnames( orig ) <- c( "id" ,
                       "orig_skill" ,
                       "scale_id" ,
                       "scale_name" )

for ( x in 1:ncol( orig )){
  orig[ , x ] <- as.character( orig[ , x ] )
}

rm( x )

orig <- unique( orig )

# Merge Datasets

skills$orig_skill <- str_trim( string = skills$orig_skill , side = "both" )

cats <- c( "2.A" , "2.B.1" , "2.B.2" , "2.B.3" , "2.B.4" , "2.B.5" ) 
names( cats ) <- filter( skills , cat == 1 )[ , 1 ]

skills <- full_join( orig , skills )

skills$id[ 71:76 ] <- cats

rm( cats ,
    orig )

# Write to .csv

setwd( "~/ProLiteracy/Normalization/Prepared" )

write.csv( skills , "skills_final.csv" )

