subroutine AttributeTransformation_Transform

use AttributeTransformation_Module
implicit real(8) (a-h,o-z)

integer ProductFrequenciesHarmonics, CounterLightCurveParameters
real(8), allocatable :: HarmonicFrequencies(:,:), TotalPower(:), PowerFrequency(:,:), PowerOdd(:), PowerEven(:)

ProductFrequenciesHarmonics = NumberFrequencies*NumberHarmonics
allocate(HarmonicFrequencies(number_LightCurves,ProductFrequenciesHarmonics),TotalPower(number_LightCurves), &
         PowerFrequency(number_LightCurves,NumberFrequencies),PowerOdd(number_LightCurves),PowerEven(number_LightCurves),&
         Attributes(number_LightCurves,NumberAttributes))

HarmonicFrequencies = 0.d0
TotalPower = 0.d0 
PowerFrequency = 0.d0
PowerOdd = 0.d0
PowerEven = 0.d0
CounterLightCurveParameters = 2 ! Accounts for intersept and slope of linear trend

! First patch of attributes (frequencies)
do i = 1, number_LightCurves ! Loop over the number of light curves (= number of objects)
 do j = 1, NumberFrequencies ! Loop over the number of frequencies
  Attributes(i,j) = LightCurveParameters(i,2+j) ! extracted frequencies are not subject to any transformation and used as they are; Attributes(i,j), with j running through 1 --> NumberFrequencies
  if(i == 1) CounterLightCurveParameters = CounterLightCurveParameters + 1 ! Accounts for frequencies
 enddo
enddo
CounterLightCurveParameters = CounterLightCurveParameters + 1 ! Accounts for Cosine Coefficient of 0th harmonic of Freq1

! Next patch of attributes (total power in each of the individual frequencies and in all of them together)
do i = 1, number_LightCurves ! Loop over the number of light curves
 k = 1; ios = 0 ! frequency index
 do j = 1, ProductFrequenciesHarmonics ! Loop over all frequencies and their harmonics
  amplitude = dsqrt(LightCurveParameters(i,3+NumberFrequencies+j)**2.d0 + LightCurveParameters(i,3+NumberFrequencies+j+ProductFrequenciesHarmonics)**2.d0) ! compute amplitude from cosine and Sine coefficients: A = dsqrt(cos**2 + sin**2)
  Attributes(i,NumberFrequencies+j) = amplitude ! Attributes(i,j), with j running through NumberFrequencies+1 --> NumberFrequencies+ProductFrequenciesHarmonics
  if(mod(j,NumberHarmonics) == 0) ios = 1 ! If ios becomes 1 this means that we are at the last harmonic of frequency k - compute the power below and switch to next frequency (k = k + 1)
  PowerFrequency(i,k) = PowerFrequency(i,k) + amplitude**2.d0 ! total power in f_k (sum of squared harmonic amplitudes)
  if(ios /= 0) then
   TotalPower(i) = TotalPower(i) + PowerFrequency(i,k) ! total power (sum of squared harmonic amplitudes of all frequencies)
   ios = 0; k = k + 1 ! Go to next frequency
  endif
 enddo
enddo

do i = 1, number_LightCurves ! Loop over the number of light curves
 do j = 1, NumberFrequencies ! Loop over the number of frequencies
  do k = 1, NumberHarmonics ! Loop over the number of harmonics
   HarmonicFrequencies(i,(j-1)*NumberHarmonics+k) = dfloat(k)*Attributes(i,j) ! Compute harmonics for each of the detected frequencies
  enddo
 enddo
enddo

! "temp" is a phase on - to + infinity interval defined as phi'_ij = arctan(sine_ij,cosine_ij) - (jf_i/f_1)*arctan(b_11,a_11) (Eq. 5.3 on page 109 in Alejandra's thesis )
! costemp and sintemp are cos(phi'_ij) and sin(phi'_ij), accordingly
! phase mapped into the half-open interval ]-pi,pi] is an attribute and is computed as arctan(sintemp,costemp)
do i = 1, number_LightCurves ! Loop over the number of light curves
 PowerOdd(i) = PowerOdd(i) + (Attributes(i,NumberFrequencies+1))**2.d0 ! Squared amplitude
 do j = 1, ProductFrequenciesHarmonics-1
  temp = (datan2(LightCurveParameters(i,3+NumberFrequencies+1+j),LightCurveParameters(i,3+NumberFrequencies+ProductFrequenciesHarmonics+1+j))) &
       - (HarmonicFrequencies(i,j+1)/HarmonicFrequencies(i,1))*(datan2(LightCurveParameters(i,3+NumberFrequencies+1),LightCurveParameters(i,3+NumberFrequencies+ProductFrequenciesHarmonics+1)))
  costemp = dcos(temp); sintemp = dsin(temp)
  Attributes(i,NumberFrequencies+ProductFrequenciesHarmonics+j) = datan2(sintemp,costemp) ! phase mapped into the half-open interval; Attributes(i,j), with j running through NumberFrequencies+ProductFrequenciesHarmonics+1 --> ProductFrequenciesHarmonics-1
! Sum of the odd and even powers
  PowerOdd(i) = PowerOdd(i) + (costemp*Attributes(i,NumberFrequencies+1+j))**2.d0
  PowerEven(i) = PowerEven(i) + (sintemp*Attributes(i,NumberFrequencies+1+j))**2.d0
 enddo
enddo
CounterLightCurveParameters = CounterLightCurveParameters + 2*ProductFrequenciesHarmonics ! Accounts for cos and sin coefficients of NumberFrequencies and their NumberHarmonics
CounterLightCurveParameters = CounterLightCurveParameters + 1 ! Accounts for variance in the time series, after linear trend-subtraction (mag^2)
CounterLightCurveParameters = CounterLightCurveParameters + NumberFrequencies ! Accounts for variance in the time series after addition subtraction of lest-squares fit with NumberHarmonics harmonics of each frequency

! Last patch of attributes
ncounter = NumberFrequencies + 2*ProductFrequenciesHarmonics - 1
do i = 1, number_LightCurves ! Loop over the number of light curves
 Attributes(i,ncounter+1) = LightCurveParameters(i,2) ! Slope of linear trend
 Attributes(i,ncounter+2) = LightCurveParameters(i,CounterLightCurveParameters+1) ! ratio of the variance after, to the variance before subtraction of least-squares fit with 4 harmonics of 'f1' (values between 0 and 1)
 Attributes(i,ncounter+3) = LightCurveParameters(i,CounterLightCurveParameters+2) ! final variance reduction due to subtraction of all the periodic signals (values close to 1 if the fit is good, close to 0 if the fit is poor)
! Attributes(i,ncounter+4) = LightCurveParameters(i,CounterLightCurveParameters+3) ! variance reduction difference between subtraction of the actual frequency and its sub-harmonic. This is relevant for the first extracted frequency only, hence for correct identification of the true orbital frequency of binary stars. Value is in percent.
 Attributes(i,ncounter+4) = dlog10(Attributes(i,1)/Attributes(i,2)) ! Log(f1/f2)

 if(Attributes(i,NumberFrequencies+2) /= 0.d0) then ! Log(amp11/amp12)
  Attributes(i,ncounter+5) = dlog10(Attributes(i,NumberFrequencies+1)/Attributes(i,NumberFrequencies+2))
 else
  Attributes(i,ncounter+5) = 9999.99999999d0
 endif
 
 Attributes(i,ncounter+6) = dlog10((PowerFrequency(i,1)/Attributes(i,NumberFrequencies+1)**2.d0) - 1.d0) ! Log((Pf1/amp11**2)-1), with Pf1=(amp11**2+amp12**2+amp13**2+amp14**2)
 Attributes(i,ncounter+7) = dlog10(Attributes(i,NumberFrequencies+1)/Attributes(i,NumberFrequencies+1+NumberHarmonics)) ! Log(amp11/amp21)
 Attributes(i,ncounter+8) = dlog10((TotalPower(i)/PowerEven(i)) - 1.d0) ! transformed odd power fraction, TotalPower is the sum of all squared amplitudes of all frequencies and PowerEven equals the total even power (sum of squares of all cosine amplitudes)
 Attributes(i,ncounter+9) = LightCurveParameters(i,CounterLightCurveParameters+3) ! Skewness in time domain
enddo

deallocate(HarmonicFrequencies,TotalPower,PowerFrequency,PowerOdd,PowerEven)

end