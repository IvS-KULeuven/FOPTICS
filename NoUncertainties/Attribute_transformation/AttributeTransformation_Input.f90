subroutine AttributeTransformation_Input

use AttributeTransformation_Module
implicit real(8) (a-h,o-z)

character(500) config_file, input_file, output_file, file_extension
character(2000) arg

call getarg(1,config_file) ! Get the name of configuration file (full path is possible)
open(1,file=trim(adjustl(config_file)),status='old',iostat=ios) ! Open configuration file and check for possible error (e.g., file does not exist)
if(ios /= 0) then
 write(*,"('Configuration file ',a,' could not be opened')") trim(adjustl(config_file))
 stop
endif

read(1,"(a)") input_file ! Get the name of input file with light curve parameters (full path is possible)
k = 0; k = index(input_file,'!'); if(k /= 0) input_file(k:) = ' ' ! Skip comments
read(1,"(a)") output_file ! Get the name of output file where transformed attributes will be stored (full path is possible)
k = 0; k = index(output_file,'!'); if(k /= 0) output_file(k:) = ' ' ! Skip comments
read(1,"(a)") file_extension ! Get file extension
k = 0; k = index(file_extension,'!'); if(k /= 0) file_extension(k:) = ' ' ! Skip comments
read(1,*) NumberFrequencies, NumberHarmonics ! Get number of frequencies and harmonics that have been extracted from light curves
close(1)

NumberProbabilityValues = NumberFrequencies + 1 ! Number of probability values
NumberLightCurveParameters = 2*(NumberFrequencies + 1) + 2*(NumberFrequencies*NumberHarmonics) + 7 ! Number of light curve parameters in the input file
NumberAttributes = 2*NumberFrequencies + 2*NumberFrequencies*NumberHarmonics + 10 ! Number of attributes to be computed

open(1,file=trim(adjustl(input_file)),status='old',iostat=ios) ! Open file with the light curve parameters and check for possible error (e.g., file does not exist)
if(ios /= 0) then
 write(*,"('File with light curve parameters ',a,' could not be opened')") trim(adjustl(input_file))
 stop
endif

!!! Get light curve parameters from the input file (all objects)

number_LightCurves = 0 ! Get number of objects(= light curves that were processed)
do
 read(1,*,iostat=ios)
 if(ios /= 0) exit
 number_LightCurves = number_LightCurves + 1 ! number of objects 
enddo
allocate(LightCurveFiles(number_LightCurves),LightCurveParameters(number_LightCurves,NumberLightCurveParameters),ProbabilityValues(number_LightCurves,NumberProbabilityValues))
rewind(1) ! Rewind input file with light curve parameters

do i = 1, number_LightCurves ! Loop over the number of objects
 read(1,"(a)") arg ! Get entire line from the input file
 k = index(arg,trim(adjustl(file_extension)),back=.true.); k = k + len(trim(adjustl(file_extension))) ! Identify end of string and beginning of float numbers in a file line
 read(arg(1:k-1),"(a)") LightCurveFiles(i) ! Get light curve file names
 read(arg(k:),*) (LightCurveParameters(i,j), j = 1, NumberLightCurveParameters), (ProbabilityValues(i,k), k = 1, NumberProbabilityValues) ! Get light curve parameters and probability values
enddo
close(1) ! Close input file with light curve parameters

k = index(output_file,'/',back=.true.); arg = ' '; write(arg,"('mkdir -p ',a)") trim(adjustl(output_file(1:k))); ios = system(trim(adjustl(arg)))
open(1,file=trim(adjustl(output_file))) ! Open output file
end