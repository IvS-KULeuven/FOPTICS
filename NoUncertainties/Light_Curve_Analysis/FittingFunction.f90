subroutine FittingFunction(ifreq) ! Build a function that will be fit to the data afterwards

use lomb_scargle
use light_curve
implicit real(8) (a-h,o-z)

real(8) FUNC(TwiceNumberHarmonics,ntimes), a1(TwiceNumberHarmonics,TwiceNumberHarmonics), b1(TwiceNumberHarmonics) 
real(8), allocatable :: FluxDetrendedTemp(:)
real(8), parameter :: TPI = 6.2831853071795865d0
integer, parameter :: NumberPointsMedian = 30
real(8) MedianHighArray(NumberPointsMedian), MedianLowArray(NumberPointsMedian), MedianHighValue, MedianLowValue
real(8) BinCentersPerFrequency(NumberBins), FluxBinnedPerFrequency(NumberBins)
integer indx1(TwiceNumberHarmonics)
integer MinimumLocation(1), MaximumLocation(1)

if(ifreq == 1) then ! We do this for the dominant extracted frequency only

! call PhaseBinning(FrequenciesExtracted(ifreq),BinCentersPerFrequency,FluxBinnedPerFrequency,BinMinimumFluxValuePrimary,0,theta1) ! Phase bin the data according to half the extracted frequency
! theta1 = theta1/Variance(ifreq)
! call PhaseBinning(FrequenciesExtracted(ifreq)*0.5d0,BinCentersPerFrequency,FluxBinnedPerFrequency,BinMinimumFluxValuePrimary,0,theta2) ! Phase bin the data according to half the extracted frequency
! theta2 = theta2/Variance(ifreq)
! if(theta2 < theta1) FrequenciesExtracted(ifreq) = FrequenciesExtracted(ifreq)*0.5d0
! write(*,*) theta1, theta2
 
! call PhaseBinning(FrequenciesExtracted(ifreq)*0.5d0,BinCentersPerFrequency,FluxBinnedPerFrequency,BinMinimumFluxValuePrimary,0,theta) ! Phase bin the data according to half the extracted frequency
 call PhaseBinning(FrequenciesExtracted(ifreq)*0.5d0,BinCentersPerFrequency,FluxBinnedPerFrequency,BinMinimumFluxValuePrimary,0) ! Phase bin the data according to half the extracted frequency

! Identify array indicies corresponding to the 0.45 - 0.55 range in phase 
 ReferenceDifferenceLeft = 10.d0; ReferenceDifferenceRight = 10.d0
 do i = 1, NumberBins

  if(dabs(BinCentersPerFrequency(i) - 0.45d0) < ReferenceDifferenceLeft .and. (BinCentersPerFrequency(i) - 0.45d0) <= 0.d0) then
   ReferenceDifferenceLeft = dabs(BinCentersPerFrequency(i) - 0.45d0)
   ileft = i ! Index corresponding to the low phase limit
  endif

  if(dabs(BinCentersPerFrequency(i) - 0.55d0) < ReferenceDifferenceRight .and. (BinCentersPerFrequency(i) - 0.55d0) >= 0.d0) then
   ReferenceDifferenceRight = dabs(BinCentersPerFrequency(i) - 0.55d0)
   iright = i ! Index corresponding to the large phase limit
  endif
 enddo

 BinMinimumFluxValueSecondary = minval(FluxBinnedPerFrequency(ileft:iright)); DecisiveDifference = dabs(BinMinimumFluxValuePrimary - BinMinimumFluxValueSecondary) ! Find secondary minimum in the phase diagram and take the difference between the primary and secondary minima
 
 allocate(FluxDetrendedTemp(ntimes)) ! Some temporary flux array
 FluxDetrendedTemp = flux_detrended ! Copy detrended flux array
 do i = 1, NumberPointsMedian ! Loop over the number of points the median flux will be computed from
  MedianHighArray(i) = maxval(FluxDetrendedTemp); MaximumLocation = maxloc(FluxDetrendedTemp); FluxDetrendedTemp(MaximumLocation(1)) = 0.d0 ! Array of NumberPointsMedian highest flux points
  MedianLowArray(i) = minval(FluxDetrendedTemp); MinimumLocation = minloc(FluxDetrendedTemp); FluxDetrendedTemp(MinimumLocation(1)) = 0.d0 ! Array of NumberPointsMedian lowest flux points
 enddo
 deallocate(FluxDetrendedTemp)

 call Sort1(NumberPointsMedian,MedianHighArray) ! Sort high flux array preparing for the median calculation 
 call Sort1(NumberPointsMedian,MedianLowArray) ! Sort low flux array preparing for the median calculation

 MedianHighValue = (MedianHighArray(NumberPointsMedian/2) + MedianHighArray(NumberPointsMedian/2+1))*0.5d0 ! Median of the NumberPointsMedian high flux values
 MedianLowValue = (MedianLowArray(NumberPointsMedian/2) + MedianLowArray(NumberPointsMedian/2+1))*0.5d0 ! Median of the NumberPointsMedian low flux values

! write(*,*) DecisiveDifference - 0.0025d0, DecisiveDifference - (MedianHighValue - MedianLowValue)*0.03d0
 if((DecisiveDifference > 0.0025d0) .and. (DecisiveDifference > (MedianHighValue - MedianLowValue)*0.03d0)) then ! Change the frequency to half the value when the two criteria in question are satisfied
  FrequenciesExtracted(ifreq) = FrequenciesExtracted(ifreq)*0.5d0
 endif

endif

!!!! Fit data with the extracted frequency and prewhiten to proceed with detection on net variablity term

do i = 1, ntimes
 FUNC(1,i) = 1.d0
enddo 

do k = 1, NumberHarmonics
 IND3 = NumberHarmonics + k

 do i = 1, ntimes
  FUNC(1+k,i) = DCOS(TPI*times(i)*k*FrequenciesExtracted(ifreq))
  FUNC(1+IND3,i) = DSIN(TPI*times(i)*k*FrequenciesExtracted(ifreq))
 enddo

enddo

! Fit the function to the data

call linfit(ntimes,TwiceNumberHarmonics,flux,weights,FUNC,a1,b1) 
call ludcmp(a1,TwiceNumberHarmonics,TwiceNumberHarmonics,indx1)
call lubksb(a1,TwiceNumberHarmonics,TwiceNumberHarmonics,indx1,b1)

FittingCoefficientsPerFrequency(ifreq,1:TwiceNumberHarmonics) = b1(1:TwiceNumberHarmonics)

do i = 1, ntimes
 val = 0.d0
 do l = 1, TwiceNumberHarmonics
  val = val + b1(l)*FUNC(l,i) ! Evaluate the best fit curve at the measurement time
 enddo
 flux(i) = flux(i) - val ! Prewhitening the data
enddo

!do l = 1, TwiceNumberHarmonics
! if(FittingCoefficientsPerFrequency(ifreq,l) < -1.d5) then
!  FittingCoefficientsPerFrequency(ifreq,l) = -1.d5
! elseif(FittingCoefficientsPerFrequency(ifreq,l) > 1.d5) then
!  FittingCoefficientsPerFrequency(ifreq,l) = 1.d5
! endif
!enddo


end