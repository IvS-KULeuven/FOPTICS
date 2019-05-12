subroutine PhasePlot(m,skewness_phase_mean,skewness_phase_median) ! Subroutine to compute and save phase diagram for the dominant frequency. It also computes skewness of the phase-binned curve
!subroutine PhasePlot(m,skewness_phase_mean,skewness_phase_median,theta) ! Subroutine to compute and save phase diagram for the dominant frequency. It also computes skewness of the phase-binned curve

use light_curve
use lomb_scargle
use input_output
implicit real(8) (a-h,o-z)

real(8) BinCentersPerFrequency(NumberBins), FluxBinnedPerFrequency(NumberBins)
integer MinimumLocation(1)
character(500) string

open(60,file=trim(adjustl(PhasePlotFiles(m))),status='unknown')
!call PhaseBinning(FrequenciesExtracted(1),BinCentersPerFrequency,FluxBinnedPerFrequency,BinMinimumFluxValuePrimary,1,theta) ! Phase bin the data according to the dominant frequency
!theta = theta/Variance(1)
call PhaseBinning(FrequenciesExtracted(1),BinCentersPerFrequency,FluxBinnedPerFrequency,BinMinimumFluxValuePrimary,1) ! Phase bin the data according to the dominant frequency
close(60) ! Close the file that contains phase-folded light curve

i = 0; i = index(PhasePlotFiles(m),'.',back=.true.); write(string,"(a,'_binned',a)") trim(adjustl(PhasePlotFiles(m)(1:i-1))), trim(adjustl(PhasePlotFiles(m)(i:)))
open(60,file=trim(adjustl(string))) ! Open a file where phase-binned light curve will be saved
do i = 1, NumberBins ! Loop over the number of phase bins
 write(60,*) BinCentersPerFrequency(i), FluxBinnedPerFrequency(i)
enddo
close(60)

call Compute_skewness(FluxBinnedPerFrequency,NumberBins,Skewness_phase_mean,Skewness_phase_median) ! Compute skewness from the phase binned light curve

end