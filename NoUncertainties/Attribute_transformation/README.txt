2*NumberFrequencies + 2*NumberFrequencies*NumberHarmonics + 9 = NumberAttributes are computed and saved into a file. On top of that, NumberFrequencies+1 probability values are saved along with the file names of all light curves (which give an extra column)

The attributes computed are (general case):

* Object identifier
* do i = 1, NumberFrequencies
   frequency(i) (cycles/day) ! NumberFrequencies extracted frequencies
  enddo
* do i = 1, NumberFrequencies
   log10(frequency(i)) (cycles/day) ! log10 NumberFrequencies of extracted frequencies
  enddo
* do i = 1, NumberFrequencies
   do j = 1, NumberHarmonics
    amplitude(i,j) (magnitude) ! amplitude of the jth harmonic of the frequency fi
   enddo
  enddo
* do j = 1, NumberHarmonics-1
   phasediff(1,j) (radians) ! phase of the amplitude of the jth harmonic of the frequency fi (amplitude_ji) if the phase of amplitude_11 = 0
  enddo
* do i = 2, NumberFrequencies
   do j = 1, NumberHarmonics
    phasediff(i,j) (radians) ! phase of the amplitude of the jth harmonic of the frequency fi (amplitude_ji) if the phase of amplitude_11 = 0
   enddo
  enddo
* 'trend': slope of the linear trend (magnitude/day)
* 'varrat': ratio of the variance after, to the variance before subtraction of least-squares fit with NumberHarmonics harmonics of 'f1' (values between 0 and 1)
* 'varred': final variance reduction due to subtraction of all the periodic signals (values close to 1 if the fit is good, close to 0 if the fit is poor)
* 'lf1f2': log10(f1/f2)
* 'la11a12': log10(amplitude11/amplitude12)
* 'lpf1pa11': log10(((Pf1/amplitude11**2)-1), with Pf1=(amplitude11**2+amplitude12**2+amplitude13**2+amplitude14**2)
* 'lpa11pa21': log10(a11/a21)
* 'lpodd': log10((TOTP/PE)-1.d0), transformed odd power fraction, TOTP (total power) is the sum of all squared amplitudes of all frequencies and PE equals the total even power (sum of squares of all cosine amplitudes)
* Skewness in time domain
* Number of zero crossings in time domain

Example for 3 frequencies and 4 harmonics:

1)Object identifier
2)'f1': main frequency present in the light curve (cycles/day)
3)'f2': second frequency (cycles/day)
4)'f3': third frequency (cycles/day)
5)'lf1': log10 of the main frequency present in the light curve (cycles/day)
6)'lf2': log10 of the second frequency present in the light curve (cycles/day)
7)'lf3': log10 of the third frequency present in the light curve (cycles/day)
8)'amp11': amplitude of the 1th harmonic of 'f1' (magnitude)
9)'amp12': amplitude of the 2th harmonic of 'f1' (mag)
10)'amp13': amplitude of the 3th harmonic of 'f1' (mag)
11)'amp14': amplitude of the 4th harmonic of 'f1' (mag)
12)'amp21': amplitude of the 1th harmonic of 'f2' (mag)
13)'amp22': amplitude of the 2th harmonic of 'f2' (mag)
14)'amp23': amplitude of the 3th harmonic of 'f2' (mag)
15)'amp24': amplitude of the 4th harmonic of 'f2' (mag)
16)'amp31': amplitude of the 1th harmonic of 'f3' (mag)
17)'amp32': amplitude of the 2th harmonic of 'f3' (mag)
18)'amp33': amplitude of the 3th harmonic of 'f3' (mag)
19)'amp34': amplitude of the 4th harmonic of 'f3' (mag)
20)'phdiff12': phase of 'amp12', if the phase of 'amp11'=0 (radians)
21)'phdiff13': phase of 'amp13', if the phase of 'amp11'=0 (radians)
22)'phdiff14': phase of 'amp14', if the phase of 'amp11'=0 (radians)
23)'phdiff21': phase of 'amp21', if the phase of 'amp11'=0 (radians)
24)'phdiff22': phase of 'amp22', if the phase of 'amp11'=0 (radians)
25)'phdiff23': phase of 'amp23', if the phase of 'amp11'=0 (radians)
26)'phdiff24': phase of 'amp24', if the phase of 'amp11'=0 (radians)
27)'phdiff31': phase of 'amp31', if the phase of 'amp11'=0 (radians)
28)'phdiff32': phase of 'amp32', if the phase of 'amp11'=0 (radians)
29)'phdiff33': phase of 'amp33', if the phase of 'amp11'=0 (radians)
30)'phdiff34': phase of 'amp34', if the phase of 'amp11'=0 (radians)
31)'trend': slope of the linear trend (magnitude/day)
32)'varrat': ratio of the variance after, to the variance before subtraction of least-squares fit with 4 harmonics of 'f1' (values between 0 and 1)
33)'varred': final variance reduction due to subtraction of all the periodic signals (values close to 1 if the fit is good, close to 0 if the fit is poor)
34)'lf1f2': log10(f1/f2)
35)'la11a12': log10(amp11/amp12)
36)'lpf1pa11': log10(((Pf1/amp11**2)-1), with Pf1=(amp11**2+amp12**2+amp13**2+amp14**2)
37)'lpa11pa21': log10(a11/a21)
38)'lpodd': log10((TOTP/PE)-1.d0), transformed odd power fraction, TOTP (total power) is the sum of all squared amplitudes of all frequencies and PE equals the total even power (sum of squares of all cosine amplitudes)
39) Skewness in time domain
40) NumberZeroCrossings