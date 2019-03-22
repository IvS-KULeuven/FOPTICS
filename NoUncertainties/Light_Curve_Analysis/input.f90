subroutine input ! Organise input: get relevant paths from the prompt, create output directories, get number of light curves and corresponding files names, etc.

use input_output ! Module with input/output variables
use light_curve
use lomb_scargle
implicit real(8) (a-h,o-z)

character(500) arg, input_file, OutFile, FileExt ! Some declarations which are relevant to this subroutine only

call getarg(1,input_file) ! Get input file name from the command line
open(1,file=trim(adjustl(input_file)),status='old',iostat=ios) ! Open the input file and check if it exists
if(ios /= 0) then
 write(*,"('Input file ',a,' was not found')") trim(adjustl(input_file))
 stop
endif

read(1,'(a)') DataDir ! Full path to directory with the data
k = 0; k = index(DataDir,'!',back=.true.); if(k /= 0) DataDir(k:) = ' ' ! Skip comments which follow the exclamation mark in the input file

read(1,'(a)') WorkDir ! Full path to the output directory
k = 0; k = index(WorkDir,'!',back=.true.); if(k /= 0) WorkDir(k:) = ' ' ! Skip comments which follow the exclamation mark in the input file

read(1,'(a)') RunName ! Individual name of the run
k = 0; k = index(RunName,'!',back=.true.); if(k /= 0) RunName(k:) = ' ' ! Skip comments which follow the exclamation mark in the input file

read(1,'(a)') FileExt ! Extension of the input files with light curves
k = 0; k = index(FileExt,'!',back=.true.); if(k /= 0) FileExt(k:) = ' ' ! Skip comments which follow the exclamation mark in the input file

read(1,'(a)') LightCurveUnits ! Light curve units: flux or magnitudes
k = 0; k = index(LightCurveUnits,'!',back=.true.); if(k /= 0) LightCurveUnits(k:) = ' ' ! Skip comments which follow the exclamation mark in the input file

read(1,*) ndeg, NFswitch ! Polynomial degree (detrending) and switch for the computation of the Nyquist frequency (0 - Kepler long-cadence, 1 - computed from mean of the inverse time steps)

read(1,*) NumberFrequenciesExtract, NumberHarmonics ! Number of frequencies to be extracted and the number of harmonics to be taken into account
TwiceNumberHarmonics = 2*NumberHarmonics + 1

read(1,*) NumberBlackListFrequencies ! Number of frequencies to be avoided on the light curve analysis

allocate(BlackListFrequencies(NumberBlackListFrequencies)) ! Allocate array of black listed frequencies to be avoided in the light curve analysis
do ifreq = 1, NumberBlackListFrequencies
 read(1,*) BlackListFrequencies(ifreq) ! Get black listed frequencies from the configuration file
enddo

close(1) ! Close input file

write(OutDir,"(a,a,'/')") trim(adjustl(WorkDir)), trim(adjustl(RunName)) ! Full path to the output directory
arg = ' '; write(arg,"('mkdir -p ',a)") trim(adjustl(OutDir))
ios = system(trim(adjustl(arg))) ! Create output directory

write(PhaseDir,"(a,'phasePlots/')") trim(adjustl(OutDir)) ! Full path to directory with phase plots
arg = ' '; write(arg,"('mkdir -p ',a)") trim(adjustl(PhaseDir))
ios = system(trim(adjustl(arg))) ! Create directory that will contain phase plots

write(AmplDir,"(a,'amplitudeSpectra/')") trim(adjustl(OutDir)) ! Full path to directory with amplitude spectra
arg = ' '; write(arg,"('mkdir -p ',a)") trim(adjustl(AmplDir))
ios = system(trim(adjustl(arg))) ! Create directory that will contain amplitude spectra

write(LightDir,"(a,'lightCurves/')") trim(adjustl(OutDir)) ! Full path to directory with amplitude spectra
arg = ' '; write(arg,"('mkdir -p ',a)") trim(adjustl(LightDir))
ios = system(trim(adjustl(arg))) ! Create directory that will contain amplitude spectra

k = 0; k = index(DataDir,'/',back=.true.)
arg = ' '; write(arg,"('find ',a,' -maxdepth 1 -type f > lightCurveFilenames')") trim(adjustl(DataDir(1:k-1))) ! Get light curve file names
ios = system(trim(adjustl(arg))) ! Execute prompt command

open(10,file='lightCurveFilenames',status='old',iostat=ios) ! Open file
if(ios /= 0) then ! Check whether the file exists and terminate the calculation if it does not
 write(*,"('The list of light curves ',a,' does not exist')") "lightCurveFilenames"
 stop
endif

number_LightCurves = 0 ! Counter for the number of light curves
do
 read(10,*,iostat=ios)
 if(ios /= 0) exit
 number_LightCurves = number_LightCurves + 1 ! Get the number of light curves by going through the entries of the file until the last record is reached
enddo
rewind(10); allocate(LightCurveFiles(number_LightCurves),PhasePlotFiles(number_LightCurves),AmplitudeSpectraFiles(number_LightCurves)) ! Allocate arrays that will contain light curve, phase plot, and amplitude spectra file names

do i = 1, number_LightCurves ! Loop over the number of entries in the file and get the light curve file names
 read(10,'(a)') LightCurveFiles(i)
 k = 0; k = index(LightCurveFiles(i),'/',back=.true.)
 write(PhasePlotFiles(i),"(a,'ph-',a)") trim(adjustl(PhaseDir)), trim(adjustl(LightCurveFiles(i)(k+1:))) ! File names (including full path) for phase plots
 write(AmplitudeSpectraFiles(i),"(a,'as-',a)") trim(adjustl(AmplDir)), trim(adjustl(LightCurveFiles(i)(k+1:))) ! File names (including full path) for amplitude spectra
! write(*,"(a,2x,a,2x,a)") trim(adjustl(LightCurveFiles(i))), trim(adjustl(PhasePlotFiles(i))), trim(adjustl(AmplitudeSpectraFiles(i))) !!! Debugging
enddo 
close(10,status='delete') ! Close the file and delete it

write(OutFile,"(a,'lcparam-',a,'.dat')") trim(adjustl(OutDir)), trim(adjustl(RunName)) ! Output file where the attributes per light curve will be stored
open(10,file=trim(adjustl(OutFile))) ! Open output file

! Computing bin centers that will be used later on for phase binning of light curves
bin_widht = 1.d0/NumberBins; half_bin_width = bin_widht*0.5d0 ! Compute bin width and half the value
allocate(BinCenters(NumberBins)); temp_bin = 0.d0 - half_bin_width !  Allocate an array that will contain bin centers
do i = 1, NumberBins ! Loop over the number of phase bins
  temp_bin = temp_bin + bin_widht
  BinCenters(i) = temp_bin ! Fill in the array of bin centers
enddo

end
