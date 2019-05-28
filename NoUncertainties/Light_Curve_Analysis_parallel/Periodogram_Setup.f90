subroutine Periodogram_Setup ! Computes some basic stuff required for periodogram calculation: total time span, Nyquist frequency, frequency resolution, etc. 

use light_curve
implicit real(8) (a-h,o-z)

TotalTimeSpan = times(ntimes) - times(1) ! Total time span for the light curve in question
FrequencyResolution = 1.d0/TotalTimeSpan ! Frequency resolution and the start frequency for the periodogram calculation
FrequencyStep = 0.1d0/TotalTimeSpan ! Frequency step for the periodogram in function of total time span
 
if(NFswitch /= 0) then ! Compute Nyquist frequency from mean of the inverse time steps
 dtinvsum = 0.d0
 do it = 2, ntimes
  dt = times(it) - times(it-1)
  if(dt > 0.d0) then
   dtinv = 1.d0/dt
  endif
  dtinvsum = dtinvsum + dtinv
 enddo
 dtinvsum = dtinvsum/real(ntimes-1,8)
 NyquistFrequency = 0.5d0*dtinvsum
else
 NyquistFrequency = 24.d0 ! Otherwise, Nyquist frequency is set to the value corresponding to the long cadence data of Kepler
endif

end