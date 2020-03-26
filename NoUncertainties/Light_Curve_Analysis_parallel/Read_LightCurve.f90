subroutine Read_LightCurve

use light_curve
implicit real(8) (a-h,o-z)

integer check_flux_flag
character(500) arg ! Some declarations relevant to this subroutine only

if(trim(adjustl(LightCurveUnits)) == 'flux' .or. trim(adjustl(LightCurveUnits)) == 'FLUX' .or. trim(adjustl(LightCurveUnits)) == 'Flux') then
 check_flux_flag = 1
 write(500,"('    Input light curve is in flux')")
else
 write(500,"('    No conversion is done as the input light curve is in magnitudes')")
 check_flux_flag = 0
endif

ntimes = 0
do
 read(60,'(a)',iostat=ios) arg ! Read a file entry into a string
 if(ios /= 0) exit ! Exit once hit the end-of-file record 
 k = 0; k = index(arg,'#') ! Check whether the entry in question contains a comment
 if(k /= 0) cycle ! Proceed to the next entry should the one in question contain a comment
 k = 0; k = index(arg,"nan"); k1 = 0; k1 = index(arg,"Nan"); k2 = 0; k2 = index(arg,"NAN")
 if(k /= 0 .or. k1 /= 0 .or. k2 /= 0) cycle
 k = 0; k = index(arg,"inf"); k1 = 0; k1 = index(arg,"Inf"); k2 = 0; k2 = index(arg,"INF")
 if(k /= 0 .or. k1 /= 0 .or. k2 /= 0) cycle
 read(arg,*,iostat=ios) t, f ! Read time and flux from a string

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! This is needed when light curves are in relative flux with the mean value of zero. This allows to avoid negative flux values. !!!!!!!!!!!!!!!!!!!!!!!!!!!!
 if(check_flux_flag == 1) f = f*1.d-6 + 1.d0
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

! if(check_flux_flag == 1 .and. (ios /= 0  .or. f < 0.d0)) cycle ! Proceed to the next file entry when the flux has no numerical value (Inf) or is negative
 ntimes = ntimes + 1 ! Number of useful data points in the file 
enddo
if(ntimes == 0) return ! Exit the subroutine when number of data points equals to 1 (e.g., all fluxes are negative or undefined)
rewind(60); allocate(times(ntimes),flux(ntimes),weights(ntimes),flux_detrended(ntimes)) ! Allocate time and flux arrays

i = 0
do
 read(60,'(a)',iostat=ios) arg ! Read a file entry into a string
 if(ios /= 0) exit ! Exit once hit the end-of-file record 
 k = 0; k = index(arg,'#') ! Check whether the entry in question contains a comment
 if(k /= 0) cycle ! Proceed to the next entry should the one in question contain a comment
 k = 0; k = index(arg,"nan"); k1 = 0; k1 = index(arg,"Nan"); k2 = 0; k2 = index(arg,"NAN")
 if(k /= 0 .or. k1 /= 0 .or. k2 /= 0) cycle
 k = 0; k = index(arg,"inf"); k1 = 0; k1 = index(arg,"Inf"); k2 = 0; k2 = index(arg,"INF")
 if(k /= 0 .or. k1 /= 0 .or. k2 /= 0) cycle
 read(arg,*,iostat=ios) t, f ! Read time and flux from a string

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! This is needed when light curves are in relative flux with the mean value of zero. This allows to avoid negative flux values. !!!!!!!!!!!!!!!!!!!!!!!!!!!!
 if(check_flux_flag == 1) f = f*1.d-6 + 1.d0
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

! if(check_flux_flag == 1 .and. (ios /= 0 .or. f < 0.d0)) cycle ! Proceed to the next file entry when the flux has no numerical value (Inf) or is negative
 i = i + 1; times(i) = t ! Store times in an array
! if(check_flux_flag == 1) then
!  flux(i) = -2.5d0*dlog10(f) ! Convert flux to magnitudes
! else
  flux(i) = f ! Store magnitude in an array
! endif
enddo

call sort2(ntimes,times,flux) ! Sort time and flux arrays by time

end
