subroutine Compute_skewness(flux,ntimes,Skewness_mean,Skewness_median)

implicit real(8) (a-h,o-z)
real(8) flux(ntimes), flux_temp(ntimes)

FLuxMean = 0.d0; flux_temp = flux
do i = 1, ntimes! Loop over the number of data points
 FluxMean = FluxMean + flux(i) ! Compute sum that will be used for the mean flux computation
enddo
FluxMean = FluxMean/real(ntimes,8) ! Mean flux

call Sort1(ntimes,flux_temp) ! Sort (temporary) flux array to re-arrange from smallest to the largest value
if(mod(ntimes,2) > 0) then ! Perform a check on whether the total number of flux points is odd or even
 FluxMedian = flux_temp(ntimes/2+1) ! Compute median flux in the case when ntimes is odd
else
 FluxMedian = (flux_temp(ntimes/2) + flux_temp(ntimes/2+1))*0.5d0 ! Compute median flux in the case when ntimes is even
endif

SecondMoment_mean = 0.d0; ThirdMoment_mean = 0.d0; SecondMoment_median = 0.d0; ThirdMoment_median = 0.d0
do i = 1, ntimes ! loop over the number of data points
 SecondMoment_mean = SecondMoment_mean + (flux(i) - FluxMean)**2.d0 ! sum for the second moment computation
 ThirdMoment_mean = ThirdMoment_mean + (flux(i) - FluxMean)**3.d0 ! sum for the third moment computation
 SecondMoment_median = SecondMoment_median + (flux(i) - FluxMedian)**2.d0 ! sum for the second moment computation
 ThirdMoment_median = ThirdMoment_median + (flux(i) - FluxMedian)**3.d0 ! sum for the third moment computation
enddo
SecondMoment_mean = SecondMoment_mean/real(ntimes,8) ! Second Moment
ThirdMoment_mean = ThirdMoment_mean/real(ntimes,8) ! Third Moment 
SecondMoment_median = SecondMoment_median/real(ntimes,8) ! Second Moment
ThirdMoment_median = ThirdMoment_median/real(ntimes,8) ! Third Moment 

Skewness_mean = ThirdMoment_mean/SecondMoment_mean**1.5d0 ! Skewness with respect to the mean
Skewness_median = ThirdMoment_median/SecondMoment_median**1.5d0 ! Skewness with respect to the median

end