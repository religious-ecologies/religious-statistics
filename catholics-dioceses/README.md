# Catholic Dioceses in North America

The file `catholic-dioceses.csv` is the primary data file, containing dioceses in the United States, Canada, and Mexico, along with latitudes and longitudes for the principal city of each see. It is a compilation of the other files in the directory.

## Sources

- Joseph Bernard Code, *Dictionary of the American Hierarchy (1789-1964)* (New York: Joseph F. Wagner, 1964), 425-26.
- catholic-hierarchy.org, [United States](http://www.catholic-hierarchy.org/country/dus2.html), [Mexico](http://www.catholic-hierarchy.org/country/dmx.html), [Canada](http://www.catholic-hierarchy.org/country/dca2.html)

## Fields 

- `diocese` is the name of the diocese, with the name of the state when necessary to clear up ambiguity
- `date_erected` is the date that the diocese was created. 
`date.metropolitan` is the date the diocese became a metropolitan see or sometimes just an archdiocese.
- `rite` is the ritual observed in the diocese. Regions or institutions with ordinary jurisdiction but not episcopal character are not included.
- `lon` and `lat` are the longitude and latitude of the city for which the see is named.
