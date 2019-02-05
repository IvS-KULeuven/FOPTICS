NumberFrequencies + 2*NumberFrequencies*NumberHarmonics + 8 = NumberAttributes are computed and saved into a file. On top of that, NumberFrequencies+1 probability values are saved along with the file names of all light curves (which give an extra column)

The attributes computed are (general case):

* Object identifier
* do i = 1, NumberFrequencies
  frequency(i) (cycles/day) ! NumberFrequencies of frequencies present in light curve
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

Example for 3 frequencies and 4 harmonics:

1)Object identifier
2)'f1': main frequency present in the light curve (cycles/day)
3)'f2': second frequency (cycles/day)
4)'f3': third frequency (cycles/day)
5)'amp11': amplitude of the 1th harmonic of 'f1' (magnitude)
6)'amp12': amplitude of the 2th harmonic of 'f1' (mag)
7)'amp13': amplitude of the 3th harmonic of 'f1' (mag)
8)'amp14': amplitude of the 4th harmonic of 'f1' (mag)
9)'amp21': amplitude of the 1th harmonic of 'f2' (mag)
10)'amp22': amplitude of the 2th harmonic of 'f2' (mag)
11)'amp23': amplitude of the 3th harmonic of 'f2' (mag)
12)'amp24': amplitude of the 4th harmonic of 'f2' (mag)
13)'amp31': amplitude of the 1th harmonic of 'f3' (mag)
14)'amp32': amplitude of the 2th harmonic of 'f3' (mag)
15)'amp33': amplitude of the 3th harmonic of 'f3' (mag)
16)'amp34': amplitude of the 4th harmonic of 'f3' (mag)
17)'phdiff12': phase of 'amp12', if the phase of 'amp11'=0 (radians)
18)'phdiff13': phase of 'amp13', if the phase of 'amp11'=0 (radians)
19)'phdiff14': phase of 'amp14', if the phase of 'amp11'=0 (radians)
20)'phdiff21': phase of 'amp21', if the phase of 'amp11'=0 (radians)
21)'phdiff22': phase of 'amp22', if the phase of 'amp11'=0 (radians)
22)'phdiff23': phase of 'amp23', if the phase of 'amp11'=0 (radians)
23)'phdiff24': phase of 'amp24', if the phase of 'amp11'=0 (radians)
24)'phdiff31': phase of 'amp31', if the phase of 'amp11'=0 (radians)
25)'phdiff32': phase of 'amp32', if the phase of 'amp11'=0 (radians)
26)'phdiff33': phase of 'amp33', if the phase of 'amp11'=0 (radians)
27)'phdiff34': phase of 'amp34', if the phase of 'amp11'=0 (radians)
28)'trend': slope of the linear trend (magnitude/day)
29)'varrat': ratio of the variance after, to the variance before subtraction of least-squares fit with 4 harmonics of 'f1' (values between 0 and 1)
30)'varred': final variance reduction due to subtraction of all the periodic signals (values close to 1 if the fit is good, close to 0 if the fit is poor)
31)'lf1f2': log10(f1/f2)
32)'la11a12': log10(amp11/amp12)
33)'lpf1pa11': log10(((Pf1/amp11**2)-1), with Pf1=(amp11**2+amp12**2+amp13**2+amp14**2)
34)'lpa11pa21': log10(a11/a21)
35)'lpodd': log10((TOTP/PE)-1.d0), transformed odd power fraction, TOTP (total power) is the sum of all squared amplitudes of all frequencies and PE equals the total even power (sum of squares of all cosine amplitudes)
36) Skewness in time domain