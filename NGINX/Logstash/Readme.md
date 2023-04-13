# Readme

## Importing Dashboard to ELK instance

* Dashboard is exported in .ndjson format from test environment
* Log in to the Kibana 
* Navigate to Stack Management
* Choose Saved Objects
* On the search page for saved objects, choose Import option and pick the ndjson file you want to import.
* Index pattern is set to logs* while writing dashboard, any change in index or index-patters may affect dashboard and changes to backend json may be required

## Optimization 

Case insensitive search is not enabled in case if its is required follow below steps to enable case insensitive search
* Make all your fields case-insensitive by using the mapping option in the index settings.
* In Kibana go to Management > Index Patterns > select your index pattern > Edit > Advanced options > Index settings > Mapping and set ignore_above to a value lower than the maximum length of your field.
* As a best practice to verify the findings it is recommended to run the data set with Splunk as well.
