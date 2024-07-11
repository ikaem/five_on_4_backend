1. use new postgres test wrapper everywhere
2. finally use that levenstein thing to find the closest match
   1. https://www.sqlitetutorial.net/sqlite-like/ 
   2. https://www.freecodecamp.org/news/fuzzy-string-matching-with-postgresql/
   3. https://drift.simonbinder.eu/docs/sql-api/custom_queries/ 
   4. https://www.google.com/search?q=postgres+Levenshtein+distance&oq=postgres+Levenshtein+distance&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIGCAEQLhhA0gEIMjAyOWowajGoAgCwAgA&sourceid=chrome&ie=UTF-8 
   5. https://medium.com/@simeon.emanuilov/levenshtein-distance-in-postgresql-a-practical-guide-ef8262f595ae 
   6. https://stackoverflow.com/questions/7730027/how-to-create-simple-fuzzy-search-with-postgresql-only
3. will need to use that Function thing for drfit - i like htis best - they use it everywhere in source code already
   1. or will makybe need tzo generate query like we have for time data 
   2. or just write somehow raw query - we will see