Total number of light curve parameters that will be computed amounts to 3*(Number of frequencies + 1) + 2*(Number of frequencies * Number of harmonics) + 4. Three extra columns are added to the input file, namely light curve file name followed by two zeros.

The light curve parameters computed are (general case):

* Object identifier
* Intercept of linear trend (magnitude)
* 'trend' = Slope of linear trend (magnitude/day)
* do i = 1, NumberFrequencies
   frequency(i) (cycles/day) ! NumberFrequencies of frequencies present in light curve
  enddo
* Cosine Coefficient of 0th harmonic of Freq1 = mean measurement value (magnitude)
* do i = 1, NumberFrequencies
   do j = 1, NumberHarmonics
    CosineCoefficient(i,j) (magnitude) ! Cosine coefficient of all harmonics of all frequencies
   enddo
  enddo
* do i = 1, NumberFrequencies
   do j = 1, NumberHarmonics
    SineCoefficient(i,j) (magnitude) ! Sine coefficient of all harmonics of all frequencies
   enddo
  enddo
* Variance in the time series, after linear trend-subtraction (mag^2)
* do i = 1, NumberFrequencies
   variance(i) (magnitude^2) ! variance in the time series after addition subtraction of lest-squares fit with NumberHarmonics harmonics of the frequency in question
  enddo
* Ratio of the variance after, to the variance before subtraction of least-squares fit with NumberHarmonics harmonics of Freq1 (no units)
* Final variance reduction due to subtraction of all the periodic signals (no units, values close to 1 if the fit is good, close to 0 if the fit is poor)
* Skewness in time domain
* Number of zero crossings in time domain
* P-value of F-test on variance difference due to subtraction of linear trend (probability)
* do i = 1, NumberFrequencies
   P-value(i) (magnitude^2) ! P-value of F-test on variance difference due to subtraction of fit with NumberHarmonics harmonics of the frequency in question
  enddo

Example for 3 frequencies and 4 harmonics:

1)Object identifier
2)Intercept of linear trend (magnitude)
3)'trend' = Slope of linear trend (magnitude/day)
4)'f1' = main frequency present in the light curve (cycles/day)
5)'f2' = second frequency (cycles/day)
6)'f3' = third frequency (cycles/day)
7)Cosine Coefficient of 0th harmonic of Freq1 = mean measurement value (magnitude)
8)Cosine Coefficient of 1th harmonic of Freq1 (magnitude)
9)Cosine Coefficient of 2th harmonic of Freq1 (magnitude) 
10)Cosine Coefficient of 3th harmonic of Freq1 (magnitude)
11)Cosine Coefficient of 4th harmonic of Freq1 (magnitude)
12)Cosine Coefficient of 1th harmonic of Freq2 (magnitude)
13)Cosine Coefficient of 2th harmonic of Freq2 (magnitude) 
14)Cosine Coefficient of 3th harmonic of Freq2 (magnitude)
15)Cosine Coefficient of 4th harmonic of Freq2 (magnitude)
16)Cosine Coefficient of 1th harmonic of Freq3 (magnitude)
17)Cosine Coefficient of 2th harmonic of Freq3 (magnitude)
18)Cosine Coefficient of 3th harmonic of Freq3 (magnitude)
19)Cosine Coefficient of 4th harmonic of Freq3 (magnitude)
20)Sine Coefficient of 1th harmonic of Freq1 (magnitude)
21)Sine Coefficient of 2th harmonic of Freq1 (magnitude)
22)Sine Coefficient of 3th harmonic of Freq1 (magnitude)
23)Sine Coefficient of 4th harmonic of Freq1 (magnitude)
24)Sine Coefficient of 1th harmonic of Freq2 (magnitude)
25)Sine Coefficient of 2th harmonic of Freq2 (magnitude)
26)Sine Coefficient of 3th harmonic of Freq2 (magnitude)
27)Sine Coefficient of 4th harmonic of Freq2 (magnitude)
28)Sine Coefficient of 1th harmonic of Freq3 (magnitude)
29)Sine Coefficient of 2th harmonic of Freq3 (magnitude)
30)Sine Coefficient of 3th harmonic of Freq3 (magnitude)
31)Sine Coefficient of 4th harmonic of Freq3 (magnitude)
32)Variance in the time series, after linear trend-subtraction (mag^2)
33)Variance in the time series, after additional subtraction of least-squares fit with 4 harmonics of Freq1 (mag^2) 
34)Variance in the time series, after additional subtraction of least-squares fit with 4 harmonics of Freq2 (mag^2) 
35)Variance in the time series, after additional subtraction of least-squares fit with 4 harmonics of Freq3 (mag^2) 
36)Ratio of the variance after, to the variance before subtraction of least-squares fit with 4 harmonics of Freq1 (no units)
37)Final variance reduction due to subtraction of all the periodic signals (no units, values close to 1 if the fit is good, close to 0 if the fit is poor)
38)Skewness_time
39)NumberZeroCrossings
40)P-value of F-test on variance difference due to subtraction of linear trend (probability)
41)P-value of F-test on variance difference due to subtraction of fit with 4 harmonics of Freq1 (probability) 
42)P-value of F-test on variance difference due to subtraction of fit with 4 harmonics of Freq2 (probability) 
43)P-value of F-test on variance difference due to subtraction of fit with 4 harmonics of Freq3 (probability)