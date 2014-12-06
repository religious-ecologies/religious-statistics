all : data/congregationalist-yearbooks/congregationalist-yearbooks-geocoded.csv

data/congregationalist-yearbooks/congregationalist-yearbooks-geocoded.csv : data/congregationalist-yearbooks/congregationalist-yearbook-*.csv
	Rscript --vanilla R/congregationalist-yearbooks.R

