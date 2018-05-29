
library( zoo )
library( purrr )
library( dplyr )
library( readxl )
library( stringr )

setwd( "~/ProLiteracy/Normalization" )

activities <- read.csv( "orig_gwas.csv" )

for( i in 1:ncol( activities )){
  activities[[ i ]] <- as.character( activities[[ i ]])
}

activities$cat <- 0

for( i in seq_along( activities$orig_title )){
  if( grepl( x = activities$orig_title[ i ], pattern = "\\(" ) == TRUE ){
    activities$cat[ i ] <- 1
    activities$orig_title[ i ] <- str_split( string = activities$orig_title[ i ], 
                                             pattern = "\\(", 
                                             n = 2, 
                                             simplify = TRUE )[,1]
  }
}

rm( i )

activities$orig_title <- str_trim( activities$orig_title )

read.csv( "https://www.onetcenter.org/dl_files/database/db_22_3_excel/Work%20Activities.xlsx" )

# Read in Original O*NET Data

orig_act <- read_excel("Original ONET Data/work_activities.xlsx", n_max = 82 ) 

orig_act <- orig_act[ , 3:6 ]

colnames( orig_act ) <- c( "id",
                           "orig_title",
                           "scale_id",
                           "scale" )

# Small correction

activities$orig_title <- str_replace( string = activities$orig_title, pattern = "\\.", replacement = "" )

merged <- left_join( orig_act, activities )

# Adding Categories

categories <- activities[ activities$cat == 1, ]

categories$id <- as.character( NA )
categories$scale_id <- as.character( NA )
categories$scale <- as.character( NA )

categories <- categories %>%
  select( id,
          orig_title,
          scale_id,
          scale,
          orig_descript,
          new_title,
          new_descript,
          cat )

merged <- full_join( merged, categories )

merged$id[ 83:86 ] <- c( "4.A.1",
                         "4.A.2",
                         "4.A.3",
                         "4.A.4" )

activities <- merged[ as.vector( order( .data = merged$id )), ]

# Clean Environment

rm( categories,
    merged,
    orig_act )

# Print to .csv

setwd( "~/ProLiteracy/Normalization/Prepared" )

write.csv( x = activities, 
           file = "activities_final.csv" )
