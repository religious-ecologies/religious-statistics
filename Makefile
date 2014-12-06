all : data/congregationalist-yearbooks/congregationalists-geocoded.csv

data/congregationalist-yearbooks/congregationalists-geocoded.csv : data/congregationalist-yearbooks/congregationalist-yearbook-*.csv
	Rscript --vanilla R/congregationalist-yearbooks.R

