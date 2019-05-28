subroutine LCA_main(proc,il) ! Performs light curve analysis (computes Lomb-Scargle periodograms, calculates attributes, etc.)

use input_output 
use light_curve 
use lomb_scargle
implicit real(8) (a-h,o-z)

integer temp(1), proc
character(500) arg, arg1

open(60,file=trim(adjustl(LightCurveFiles(il))),status='old',iostat=ios) ! Open a light curve file and check whether it exists
if(ios /= 0) then
 write(*,"('Proc',i4.4,': Light curve ',a,' was not found')") proc, trim(adjustl(LightCurveFiles(il)))
 stop
endif
 
write(500,*) ! Print some info
write(500,"('Processing ',a,' ...')") trim(adjustl(LightCurveFiles(il)))

call Read_LightCurve ! Get the light curve from a file: times vs. flux (convert flux to magnitudes)
close(60); if(ntimes < 100) write(500,"('WARNING: number of light curve data points is less than 100: ntimes = ',i3.3)") ntimes ! Close light curve file and print warning when number of data points is less than 100
if(ntimes == 0) then ! Skip the light curve when ntimes equals zero
 write(500,"('Light curve ',a,' has NOT been processed because of undefined magnitudes')") trim(adjustl(LightCurveFiles(il))) ! Print some info
 return
endif

call Periodogram_Setup ! Compute some basic stuff required for periodogram calculation: total time span, Nyquist frequency, frequency resolution, etc.
call LightCurve_statistic(ntimes,flux,FluxRawMean,VarianceRaw) ! Do some raw light curve statistics (mean and variance)
t0 = times(1); call Subtract_RefValue(ntimes,times,t0) ! Subtract T0 from times array (times array is changed here and will have 0 as starting element and times(ntimes)-times(1) as the end element)
call Subtract_RefValue(ntimes,flux,FluxRawMean) ! Subtract mean magnitude from the raw flux array (flux array is changed here)
 
kk = 0; kk = index(LightCurveFiles(il),'/',back=.true.); kk1 = 0; kk1 = index(LightCurveFiles(il),'.',back=.true.)
write(arg,"(a,'lc-',a)") trim(adjustl(LightDir)), trim(adjustl(LightCurveFiles(il)(kk+1:))) ! File names (including full path) for light curves
write(arg1,"(a,'lc-',a,'_detrended',a)") trim(adjustl(LightDir)), trim(adjustl(LightCurveFiles(il)(kk+1:kk1-1))), trim(adjustl(LightCurveFiles(il)(kk1:))) ! File names (including full path) for light curves
open(60,file=trim(adjustl(arg))) ! Original light curve
do ii = 1, ntimes
 write(60,*) times(ii), flux(ii)
enddo
close(60)
 
weights = 1.d0 ! setting weights to unity
if(ndeg /= 0) call Subtract_Polynomial ! Detrend the data by fitting and subtracting a polynomial (the flux array will be changed)
flux_detrended = flux ! Store detrended flux in a separate array (will be used for a phase plot at the end)
 
NumberZeroCrossings = 0 ! Number of zero crossings counter initiation
open(60,file=trim(adjustl(arg1))) ! Detrended light curve
do ii = 1, ntimes
 write(60,*) times(ii), flux(ii)
 if(ii /= 1) then ! compute number of zero crossings
  if((flux(ii) < 0.d0 .and. flux(ii-1) > 0.d0) .or. (flux(ii) > 0.d0 .and. flux(ii-1) < 0.d0)) NumberZeroCrossings = NumberZeroCrossings + 1
 endif
enddo
close(60)

call Compute_skewness(flux,ntimes,Skewness_time_mean,Skewness_time_median) ! Compute skewness
 
NumberFrequencies = dint((NyquistFrequency - FrequencyResolution)/FrequencyStep) + 1 ! Total number of frequencies
allocate(Variance(NumberFrequenciesExtract+1),FrequenciesExtracted(NumberFrequenciesExtract),FittingCoefficientsPerFrequency(NumberFrequenciesExtract,TwiceNumberHarmonics)) ! Allocate variance array
allocate(FrequencyProbability(NumberFrequenciesExtract+1))
allocate(SS(NumberFrequencies),SC(NumberFrequencies),SS2(NumberFrequencies),SC2(NumberFrequencies),F1(NumberFrequencies),PS(NumberFrequencies),S0N(ntimes),C0N(ntimes), &
         DEN(NumberFrequencies),SDFN(ntimes),CDFN(ntimes))
 
do ifr = 1, NumberFrequenciesExtract ! Loop over the number of frequencies to be extracted
  
 call LightCurve_statistic(ntimes,flux,FluxDetrendedMean,VarianceDetrended) ! Do some detrended light curve statistics (mean and variance) 

 call Subtract_RefValue(ntimes,flux,FluxDetrendedMean) ! Subtract mean magnitude from (detrended) flux array (flux array is changed here)     

 Variance(ifr) = VarianceDetrended  ! Keep variance of the light curve before the frequency in question is prewhitened 
  
 call LombScargle_Periodogram(ifr) ! Compute Lomb-Scargle periodogram (uses global variables and arrays - times, flux, ntimes, etc. - without changing them; the routine related arrays are changed each time the subroutine is called and the changed variables/arrays are used as starting values in the next iteration)

 PS(1:NumberFrequencies) = dsqrt(PS(1:NumberFrequencies))*dsqrt(4.d0/real(ntimes,8))   ! Normalize the periodogram
        
 if(ifr == 1) then ! Write the first amplitude spectrum to a file
  open(70,file=trim(adjustl(AmplitudeSpectraFiles(il))),status='unknown')
  do i = 1, NumberFrequencies
   write(70,*) F1(i), PS(i)
  enddo
  close(70)
 endif
   
 do ! Infinite loop to skip frequencies from a black list: 1) the highest amplitude peak is detected and its amplitude is set artificially to zero when the frequency in question matches the one from the black list; 2) the cycle repeats until a frequency is found that does not match any of those from the black list (ios = 0 condition)
  ios = 0; PeakValue = maxval(PS); temp = maxloc(PS); FrequenciesExtracted(ifr) = F1(temp(1)) ! Get the highest peak in the periodogram
  do ibf = 1, NumberBlackListFrequencies ! Check whether the highest detected peak is black listed (e.g., instrumental frequency)
   if(dabs(FrequenciesExtracted(ifr) - BlackListFrequencies(ibf)) <= FrequencyResolution) then ! The highest amplitude frequency is the one from a black list" (within the frequency resolution)
    PS(temp(1)) = 0.d0; ios = 1 ! Set the amplitude of the black listed frequency artificially to zero (ios = 1 indicates that the frequency in question coincides with the one from a black list) 
   endif
   if(ios /= 0) exit ! Exit the loop over the number of black listed frequency when the match has been found
  enddo
  if(ios == 0) exit ! Exit the infinite loop when no match to any of the black listed frequencies has been found
 enddo

 call FittingFunction(ifr) ! Fit the frequency in question + N harmonics to the data and subtract the fitted function from the observations (the flux array is modified as the contribution from the first detected frequency and its harmonics is removed)
 
enddo
 
call LightCurve_statistic(ntimes,flux,FluxResidualMean,VarianceResidual) ! Do some statistics (mean and variance) on the residual light curve
Variance(NumberFrequenciesExtract+1) = VarianceResidual ! Store the computed variance in the Variance array
 
call ftest(VarianceRaw,ntimes,Variance(1),ntimes,ftemp,prob) ! Perform statistical F-test (one tailed) to check if the variances before and after subtraction of the best fit are significantly different. If the returned probability value PROB is close to zero, the variances are significantly different. If PROB is close to one, the variances are not significantly different. If a significance level is chosen, this test can be used to indicate the significance of the found frequencies
FrequencyProbability(1) = prob ! Raw data vs. detrended
 
do ifr = 1, NumberFrequenciesExtract ! Loop over the number of extracted frequencies
 call ftest(Variance(ifr),ntimes,Variance(ifr+1),ntimes,ftemp,prob)
 FrequencyProbability(ifr+1) = prob ! 1st frequency subtracted vs. original detrended, 2nd frequency subtracted vs. 1st frequency subtracted, etc.
enddo
 
! call PhasePlot(m,skewness_phase_mean,skewness_phase_median,theta) ! Make a phase plot for the dominant frequency and save it into a file
call PhasePlot(il,skewness_phase_mean,skewness_phase_median) ! Make a phase plot for the dominant frequency and save it into a file
 
write(10,fmt="(a,'   0.00000000     0.00000000  ',1000(f16.8,1x))") trim(adjustl(LightCurveFiles(il))), (FrequenciesExtracted(i), i = 1, NumberFrequenciesExtract), & ! Output
         FittingCoefficientsPerFrequency(1,1), (FittingCoefficientsPerFrequency(i,2:NumberHarmonics+1), i = 1, NumberFrequenciesExtract), &
         (FittingCoefficientsPerFrequency(i,NumberHarmonics+2:TwiceNumberHarmonics), i = 1, NumberFrequenciesExtract), (Variance(i), i = 1, NumberFrequenciesExtract+1), &
!          Variance(2)/Variance(1), (1.d0 - Variance(NumberFrequenciesExtract+1)/Variance(1)), VarianceReduction, skewness_time, skewness_phase, (FrequencyProbability(i), i = 1, NumberFrequenciesExtract+1)
         Variance(2)/Variance(1), (1.d0 - Variance(NumberFrequenciesExtract+1)/Variance(1)), skewness_time_mean, real(NumberZeroCrossings,8), (FrequencyProbability(i), i = 1, NumberFrequenciesExtract+1) 
! write(100,"(a,1x,1000(f16.8,1x))") trim(adjustl(LightCurveFiles(m))), skewness_time_mean, skewness_time_median, skewness_phase_mean, skewness_phase_median
write(500,"('Light curve ',a,' has been processed')") trim(adjustl(LightCurveFiles(il))) ! Print some info
deallocate(times,flux,flux_detrended,weights,Variance,FrequenciesExtracted,FittingCoefficientsPerFrequency,FrequencyProbability)
deallocate(SS,SC,SS2,SC2,F1,PS,S0N,C0N,DEN,SDFN,CDFN)

end
