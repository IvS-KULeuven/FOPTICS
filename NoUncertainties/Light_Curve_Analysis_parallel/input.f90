subroutine input(proc) ! Organise input: get relevant paths from the prompt, create output directories, get number of light curves and corresponding files names, etc.

use input_output ! Module with input/output variables
use light_curve
use lomb_scargle
implicit real(8) (a-h,o-z)
include 'mpif.h'

character(500) arg, Name_user, input_file, FileExt, OutFile ! Some declarations which are relevant to this subroutine only
integer proc

call getarg(1,input_file) ! Get input file name from the command line
open(1,file=trim(adjustl(input_file)),status='old',iostat=ios) ! Open the input file and check if it exists
if(ios /= 0) then
 write(*,"('Input file ',a,' was not found')") trim(adjustl(input_file))
 stop
endif

if(proc == 0) then ! We involve main process only
 arg = ' '; write(arg,"('echo $USER > temp_user.dat')"); ios = system(trim(adjustl(arg))) ! Write use name into a file
 open(201,file='temp_user.dat'); read(201,"(a)") Name_user; close(201,status='delete') ! Get user name from file
endif
call mpi_barrier(mpi_comm_world,ios)
call mpi_bcast(Name_user,len(Name_user),mpi_character,0,mpi_comm_world,ios) ! Distribute User name to all child processes

read(1,'(a)') DataDir ! Full path to directory with the data
k = 0; k = index(DataDir,'!',back=.true.); if(k /= 0) DataDir(k:) = ' ' ! Skip comments which follow the exclamation mark in the input file

read(1,'(a)') WorkDir ! Full path to directory with the data
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

write(LogDir,"(a,'LogFiles/')") trim(adjustl(OutDir)) ! Full path to directory with amplitude spectra
arg = ' '; write(arg,"('mkdir -p ',a)") trim(adjustl(LogDir))
ios = system(trim(adjustl(arg))) ! Create directory that will contain amplitude spectra

if(proc == 0) then ! We involve main process only
 k = 0; k = index(DataDir,'/',back=.true.)
 arg = ' '; write(arg,"('find ',a,' -maxdepth 1 -type f > ',a,'lightCurveFilenames')") trim(adjustl(DataDir(1:k-1))), trim(adjustl(OutDir)) ! Get light curve file names
 ios = system(trim(adjustl(arg))) ! Execute prompt command

 arg = ' '; write(arg,"(a,'lightCurveFilenames')") trim(adjustl(OutDir))
 open(10,file=trim(adjustl(arg)),status='old',iostat=ios) ! Open file
 if(ios /= 0) then ! Check whether the file exists and terminate the calculation if it does not
  write(*,"('The list of light curves ',a,' does not exist')") trim(adjustl(arg))
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
 enddo 
 close(10,status='delete') ! Close the file and delete it
endif
call mpi_barrier(mpi_comm_world,ios) ! synchronising individual processes in time
call mpi_bcast(number_LightCurves,1,mpi_integer,0,mpi_comm_world,ios) ! Number of light curves to all child processes
if(proc /= 0) allocate(LightCurveFiles(number_LightCurves),PhasePlotFiles(number_LightCurves),AmplitudeSpectraFiles(number_LightCurves)) ! array allocations on child processes

do i = 1, number_LightCurves ! loop over the number of light curves
 call mpi_bcast(LightCurveFiles(i),len(LightCurveFiles(i)),mpi_character,0,mpi_comm_world,ios) ! light curve file names to all child processes
 call mpi_bcast(PhasePlotFiles(i),len(PhasePlotFiles(i)),mpi_character,0,mpi_comm_world,ios) ! phase curve file names to all child processes
 call mpi_bcast(AmplitudeSpectraFiles(i),len(AmplitudeSpectraFiles(i)),mpi_character,0,mpi_comm_world,ios) ! amplitude spectra file names to al child processes
enddo

write(OutFile,"(a,'lcparam-',a,'_proc',i4.4,'.dat')") trim(adjustl(OutDir)), trim(adjustl(RunName)), proc ! Output file where the attributes per light curve will be stored
open(10,file=trim(adjustl(OutFile))) ! Open output file

write(OutFileMerged,"(a,'lcparam-',a,'.dat')") trim(adjustl(OutDir)), trim(adjustl(RunName)) ! Output file where the attributes per light curve will be stored

! Computing bin centers that will be used later on for phase binning of light curves
bin_widht = 1.d0/NumberBins; half_bin_width = bin_widht*0.5d0 ! Compute bin width and half the value
allocate(BinCenters(NumberBins)); temp_bin = 0.d0 - half_bin_width !  Allocate an array that will contain bin centers
do i = 1, NumberBins ! Loop over the number of phase bins
  temp_bin = temp_bin + bin_widht
  BinCenters(i) = temp_bin ! Fill in the array of bin centers
enddo

arg = ' '; write(arg,"(a,'LCAnalysis_logfile_proc',i4.4,'.txt')") trim(adjustl(LogDir)), proc; open(500,file=trim(adjustl(arg))) ! Logfile

end
