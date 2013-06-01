# Run all the R scripts in the project

# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

# Inputs and outputs
RSCRIPTS = FileList["*.R"]
ROUTS = RSCRIPTS.ext(".Rout")

desc "Make all outputs."
task :default => [:rscripts]

# Run all the R scripts
task :rscripts => ROUTS

# Generic rule to run an R script
rule '.Rout' => '.R' do |task|
  puts "Running #{task.source}"
  sh "R CMD BATCH #{task.source}"
end

# Cleanup
require "rake/clean"
CLEAN.include("*.Rout," "*.RData")
CLOBBER.include("*.png")

desc "Rebuild all outputs from scratch."
task :rebuild => [:clobber, :default] 
