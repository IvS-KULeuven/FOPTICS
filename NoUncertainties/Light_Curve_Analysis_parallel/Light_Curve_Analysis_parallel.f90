program Light_Curve_Analysis_parallel

use input_output ! Module with input/output variables
use light_curve
use lomb_scargle
implicit real(8) (a-h,o-z)
include 'mpif.h'

!! Local declarations !!

integer proc
character(500) string, OutFile

call mpi_init(ios) ! Initialize MPI
call mpi_comm_size(mpi_comm_world,nproc,ios) ! Total number of processes
call mpi_comm_rank(mpi_comm_world,proc,ios) ! Process rank
if(proc == 0) time_start = mpi_wtime(ios) ! Start time

call input(proc) ! Get some input from configuration file and set up a few things for the calculations

number_lightcurves_per_cpu = number_LightCurves/nproc ! Number of main loops (=number of perturbations per CPU; e.g., 120 perturbations/50 CPUs = 2 perturbations per CPU with 20 left)
number_lightcurves_last_loop = mod(number_LightCurves,nproc) ! Compute number of perturbations left after main loops have been completed (in the above example, these are 20 perturbations that need to be computed using 20 CPUs out of available 50)

if(proc == 0) then
 write(*,*)
 write(*,"('Number of light curves per process = ',i7,'   Total number of light curves in the main loop = ',i7,'   Number of processes = ',i4)") number_lightcurves_per_cpu, nproc*number_lightcurves_per_cpu, nproc
 write(*,*)
endif
do i = 1, number_lightcurves_per_cpu ! Main loop
 call LCA_main(proc,(i-1)*nproc+proc+1)

 if(proc == 0) then
  ios = mod(i,10)
  if(ios == 0) write(*,"(i7.7,' out of ',i7.7,' lightcurves have been processed')") i*nproc, nproc*number_lightcurves_per_cpu+number_lightcurves_last_loop
 endif
enddo

call mpi_barrier(mpi_comm_world,ios) ! synchronising individual processes in time
if(number_lightcurves_last_loop /= 0) then ! Extra calculations if applicable (not all light curves were processed in the main loop)
 if(proc == 0) then
  write(*,*)
  write(*,"('Number of extra calculations = ',i3,'  Total number of light curves = ',i5)") number_lightcurves_last_loop, nproc*number_lightcurves_per_cpu+number_lightcurves_last_loop
  write(*,*)
 endif
 call mpi_barrier(mpi_comm_world,ios)
 
 if(proc < number_lightcurves_last_loop) then
  call LCA_main(proc,(i-1)*nproc+proc+1)
 endif
 if(proc == 0) write(*,"(i7.7,' out of ',i7.7,' lightcurves have been processed')") nproc*number_lightcurves_per_cpu+number_lightcurves_last_loop, nproc*number_lightcurves_per_cpu+number_lightcurves_last_loop
else
 if(proc == 0) write(*,"(i7.7,' out of ',i7.7,' lightcurves have been processed')") nproc*number_lightcurves_per_cpu+number_lightcurves_last_loop, nproc*number_lightcurves_per_cpu+number_lightcurves_last_loop
endif

call mpi_barrier(mpi_comm_world,ios)
close(10) ! Close output file
deallocate(LightCurveFiles,PhasePlotFiles,AmplitudeSpectraFiles,BlackListFrequencies,BinCenters)

if(proc == 0) then
 do i = 1, nproc ! Merging individual light curve files
  OutFile = ' '; write(OutFile,"(a,'lcparam-',a,'_proc',i4.4,'.dat')") trim(adjustl(OutDir)), trim(adjustl(RunName)), i-1 ! Output file where the attributes per light curve will be stored
  string = ' '; write(string,"('cat ',a,' >> ',a)") trim(adjustl(OutFile)), trim(adjustl(OutFileMerged))
  ios = system(trim(adjustl(string)))
 enddo
 time_end = mpi_wtime(ios)
 nsec = time_end - time_start
 nmin = nsec/60; nh = nmin/60
 nmin = nmin - nh*60
 nsec = nsec - nmin*60 - nh*3600
 write(*,*)
 write(*,*) 'Calculation time: ', nh, ' h', nmin, ' min', nsec, ' sec'
endif
call mpi_barrier(mpi_comm_world,ios)
call mpi_finalize(ios)

end program Light_Curve_Analysis_parallel
