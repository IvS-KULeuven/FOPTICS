subroutine FittingFunction(ifreq,ilight) ! Build a function that will be fit to the data afterwards

use lomb_scargle
use light_curve
implicit real(8) (a-h,o-z)

real(8) FUNC(TwiceNumberHarmonics,ntimes), a1(TwiceNumberHarmonics,TwiceNumberHarmonics), b1(TwiceNumberHarmonics) 
real(8), allocatable :: flux_temp(:,:), variance_temp(:), b1_temp(:,:), FluxDetrendedTemp(:)
real(8), parameter :: TPI = 6.2831853071795865d0
integer, parameter :: NumberPointsMedian = 30
real(8) MedianHighArray(NumberPointsMedian), MedianLowArray(NumberPointsMedian), MedianHighValue, MedianLowValue
real(8) BinCentersPerFrequency(NumberBins), FluxBinnedPerFrequency(NumberBins)
integer indx1(TwiceNumberHarmonics)
integer MinimumLocation(1), MaximumLocation(1)

icheckfrequency = 0 ! Set the period doubling candidate flag to zero

if(ifreq == 1) then ! We do this for the dominant extracted frequency only

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

 if((DecisiveDifference > 0.0025d0) .and. (DecisiveDifference > (MedianHighValue - MedianLowValue)*0.02d0)) then ! Change the frequency to half the value when the two criteria in question are satisfied
  FrequenciesExtracted(ifreq) = FrequenciesExtracted(ifreq)*0.5d0
  icheckfrequency = 1 ! Flag for the period doubling candidate
 endif

endif

select case (icheckfrequency) ! Check for the period doubling candidacy. If the period is a candidate, we will compare variances between fitting for the actual period and twice the value
	case(1)
		nruns = 2
		allocate(variance_temp(nruns))
	case default
		nruns = 1	
end select
FrequencyTemp = FrequenciesExtracted(ifreq)*0.5d0
allocate(flux_temp(nruns,ntimes),b1_temp(nruns,TwiceNumberHarmonics))

do j = 1, nruns ! loop over frequency in question, its sub-harmonic and harmonic, i.e. 0.5*f, f, and 2*f. This concerns the first extracted frequency only

 do i = 1, ntimes
  FUNC(1,i) = 1.d0
 enddo 

 FrequencyTemp = FrequencyTemp*2.d0 ! 

 do k = 1, NumberHarmonics
  IND3 = NumberHarmonics + k

  do i = 1, ntimes
   FUNC(1+k,i) = DCOS(TPI*times(i)*k*FrequencyTemp)
   FUNC(1+IND3,i) = DSIN(TPI*times(i)*k*FrequencyTemp)
  enddo

 enddo

! Fit the function to the data

 call linfit(ntimes,TwiceNumberHarmonics,flux,weights,FUNC,a1,b1) 
 call ludcmp(a1,TwiceNumberHarmonics,TwiceNumberHarmonics,indx1)
 call lubksb(a1,TwiceNumberHarmonics,TwiceNumberHarmonics,indx1,b1)

 b1_temp(j,1:TwiceNumberHarmonics) = b1(1:TwiceNumberHarmonics)

!FittingCoefficientsPerFrequency(ifreq,1:TwiceNumberHarmonics) = b1(1:TwiceNumberHarmonics)

 do i = 1, ntimes
  val = 0.d0
  do l = 1, TwiceNumberHarmonics
   val = val + b1(l)*FUNC(l,i) ! Evaluate the best fit curve at the measurement time
  enddo
  flux_temp(j,i) = flux(i) - val
 enddo

if(icheckfrequency == 1) then 
 call LightCurve_statistic(ntimes,flux_temp(j,1:ntimes),ppp,variance_temp(j))
endif

enddo

select case (icheckfrequency) ! In case the period in question is a candidate for doubling
	case(1)
		VarianceReduction = 100.d0 - variance_temp(1)*100.d0/variance_temp(2)
		if(VarianceReduction > 25.d0) then ! Period will be doubled
		 flux(1:ntimes) = flux_temp(1,1:ntimes)
		 FittingCoefficientsPerFrequency(ifreq,1:TwiceNumberHarmonics) = b1_temp(1,1:TwiceNumberHarmonics)
		else ! The actual extracted period will remain
		 flux(1:ntimes) = flux_temp(2,1:ntimes)
		 FittingCoefficientsPerFrequency(ifreq,1:TwiceNumberHarmonics) = b1_temp(2,1:TwiceNumberHarmonics)
		 FrequenciesExtracted(ifreq) = FrequenciesExtracted(ifreq)*2.0d0
		endif
		deallocate(variance_temp)
	case default
		flux(1:ntimes) = flux_temp(1,1:ntimes)
		FittingCoefficientsPerFrequency(ifreq,1:TwiceNumberHarmonics) = b1_temp(1,1:TwiceNumberHarmonics)
end select
deallocate(flux_temp,b1_temp)

!do l = 1, TwiceNumberHarmonics
! if(FittingCoefficientsPerFrequency(ifreq,l) < -1.d5) then
!  FittingCoefficientsPerFrequency(ifreq,l) = -1.d5
! elseif(FittingCoefficientsPerFrequency(ifreq,l) > 1.d5) then
!  FittingCoefficientsPerFrequency(ifreq,l) = 1.d5
! endif
!enddo


end