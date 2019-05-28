subroutine LightCurve_statistic(n,x,xmean,xvar)

implicit real(8) (a-h,o-z)
real(8) x(n)

xmean = 0.d0 ! Compute the sum over all time steps
do i = 1, n
 xmean = xmean + x(i)
enddo
xmean = xmean/real(n,8) ! Compute the mean of the measurements

xvar = 0.d0 ! Compute variance
do i = 1, n
 xvar = xvar + (x(i) - xmean)**2.d0
enddo
xvar = xvar/real(n-1,8) ! Variance of the raw, non-detrended data

end