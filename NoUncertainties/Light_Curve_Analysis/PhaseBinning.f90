subroutine PhaseBinning(frequency,BinCentersPerFrequency,FluxBinned,BinMinimumFluxValue,iprint)

use light_curve
implicit real(8) (a-h,o-z)

real(8) FluxBinned(NumberBins), PhaseDifference(NumberBins), BinCentersPerFrequency(NumberBins), phase(ntimes)
integer NumberPointsPerBin(NumberBins)
integer MinimumLocation(1)

FluxBinned = 0.d0; NumberPointsPerBin = 0
do it = 1, ntimes ! Loop over the number of light curve point in time domain
 phase(it) = dmod((times(it) - times(1))*frequency,1.d0) ! Compute phase
 PhaseDifference = dabs(BinCenters - phase(it)) ! Compute difference between current phase point and all bin centers to figure out in which particular bin the point will fall
 PhaseDifferenceMinimum = minval(PhaseDifference); MinimumLocation = minloc(PhaseDifference) ! Find bin center that is closest to the current phase point
 FluxBinned(MinimumLocation(1)) = FluxBinned(MinimumLocation(1)) + flux_detrended(it) ! Accumulate flux
 NumberPointsPerBin(MinimumLocation(1)) = NumberPointsPerBin(MinimumLocation(1)) + 1 ! Accumulate number of points per bin
enddo

FluxBinnedMean = sum(FluxBinned, MASK=FluxBinned/=0.d0)/real(NumberBins,8) ! Compute mean of the flux in phase domain

do i = 1, NumberBins ! Loop over the number of phase bins
 if(FluxBinned(i) /= 0) then ! When the bin is not empty
  FluxBinned(i) = FluxBinned(i)/NumberPointsPerBin(i) ! Compute flux in that bin 
 else ! When the bin is empty
  FluxBinned(i) = FluxBinnedMean ! Set the flux to the mean value
 endif
enddo

BinMinimumFluxValue = minval(FluxBinned); MinimumLocation = minloc(FluxBinned); BinMinimumPhaseValue = BinCenters(MinimumLocation(1)) ! Minimum value of the phase binned flux and the corresponding array index and phase value
do i = 1, NumberBins ! Loope over the number of phase bins
 BinCentersPerFrequency(i) = BinCenters(i) - BinMinimumPhaseValue ! Apply phase shift so that minimum binned flux value occurs at phase zero
 if(BinCentersPerFrequency(i) < 0.d0) BinCentersPerFrequency(i) = BinCentersPerFrequency(i) + 1.d0
enddo
call Sort2(NumberBins,BinCentersPerFrequency,FluxBinned) ! Re-sort the bins and flux arrays so that phase run from smallest to largest

if(iprint == 1) then ! Saving un-binned phase curve into a file
 do it = 1, ntimes ! Loop over the number of light curve data points
  phase(it) = phase(it) - BinMinimumPhaseValue ! Do the same what we have done for the binned phase curve but this time for the un-binned data
  if(phase(it) < 0.d0) phase(it) = phase(it) + 1.d0
  write(60,*) phase(it), flux_detrended(it)
 enddo
endif

end