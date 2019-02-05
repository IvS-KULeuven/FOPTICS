subroutine Compute_skewness(flux,ntimes,Skewness)

implicit real(8) (a-h,o-z)
real(8) flux(ntimes)

FLuxMean = 0.d0
do i = 1, ntimes! Loop over the number of data points
 FluxMean = FluxMean + flux(i) ! Compute sum that will be used for the mean flux computation
enddo
FluxMean = FluxMean/real(ntimes,8) ! Mean flux

SecondMoment = 0.d0; ThirdMoment = 0.d0
do i = 1, ntimes ! loop over the number of data points
 SecondMoment = SecondMoment + (flux(i) - FluxMean)**2.d0 ! sum for the second moment computation
 ThirdMoment = ThirdMoment + (flux(i) - FluxMean)**3.d0 ! sum for the third moment computation
enddo
SecondMoment = SecondMoment/real(ntimes,8) ! Second Moment
ThirdMoment = ThirdMoment/real(ntimes,8) ! Third Moment 
Skewness = ThirdMoment/SecondMoment**1.5d0 ! Skewness

end