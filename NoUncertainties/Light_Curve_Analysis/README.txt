Total number of light curve parameters that will be computed amounts to 3*(Number of frequencies + 1) + 2*(Number of frequencies * Number of harmonics) + 5. Three extra columns are added to the input file, namely light curve file name followed by two zeros.

The light curve parameters computed are (general case):

* Object identifier
* Intercept of linear trend
* 'trend' = Slope of linear trend
* do i = 1, NumberFrequencies
   frequency(i) (cycles/day) ! NumberFrequencies of frequencies present in light curve
  enddo
* Cosine Coefficient of 0th harmonic of Freq1 = mean measurement value
* do i = 1, NumberFrequencies
   do j = 1, NumberHarmonics
    CosineCoefficient(i,j) ! Cosine coefficient of all harmonics of all frequencies
   enddo
  enddo
* do i = 1, NumberFrequencies
   do j = 1, NumberHarmonics
    SineCoefficient(i,j) ! Sine coefficient of all harmonics of all frequencies
   enddo
  enddo
* Variance in the time series, after trend subtraction
* do i = 1, NumberFrequencies
   variance(i) ! variance in the time series after addition subtraction of lest-squares fit with NumberHarmonics harmonics of the frequency in question
  enddo
* Ratio of the variance after, to the variance before subtraction of least-squares fit with NumberHarmonics harmonics of Freq1
* Final variance reduction due to subtraction of all the periodic signals (no units, values close to 1 if the fit is good, close to 0 if the fit is poor)
* Skewness in time domain
* Number of zero crossings in time domain, normalized to the total number of points in a time-series
* Ratio of the squared sum of residuals of magnitudes/fluxes that are either brighter/larger than or fainter/smaller than the mean magnitude/flux (A = sigma_faint/sigma_bright, where sigma^2 = (1/N)*sum_i^N{(m_i - mean)**2})
* P-value of F-test on variance difference due to subtraction of linear trend (probability)
* do i = 1, NumberFrequencies
   P-value(i) ! P-value of F-test on variance difference due to subtraction of fit with NumberHarmonics harmonics of the frequency in question
  enddo

Example for 3 frequencies and 4 harmonics:

1)Object identifier
2)Intercept of linear trend
3)'trend' = Slope of linear trend
4)'f1' = main frequency present in the light curve (cycles/day)
5)'f2' = second frequency (cycles/day)
6)'f3' = third frequency (cycles/day)
7)Cosine Coefficient of 0th harmonic of Freq1 = mean measurement value
8)Cosine Coefficient of 1th harmonic of Freq1
9)Cosine Coefficient of 2th harmonic of Freq1
10)Cosine Coefficient of 3th harmonic of Freq1
11)Cosine Coefficient of 4th harmonic of Freq1
12)Cosine Coefficient of 1th harmonic of Freq2
13)Cosine Coefficient of 2th harmonic of Freq2
14)Cosine Coefficient of 3th harmonic of Freq2
15)Cosine Coefficient of 4th harmonic of Freq2
16)Cosine Coefficient of 1th harmonic of Freq3
17)Cosine Coefficient of 2th harmonic of Freq3
18)Cosine Coefficient of 3th harmonic of Freq3
19)Cosine Coefficient of 4th harmonic of Freq3
20)Sine Coefficient of 1th harmonic of Freq1
21)Sine Coefficient of 2th harmonic of Freq1
22)Sine Coefficient of 3th harmonic of Freq1
23)Sine Coefficient of 4th harmonic of Freq1
24)Sine Coefficient of 1th harmonic of Freq2
25)Sine Coefficient of 2th harmonic of Freq2
26)Sine Coefficient of 3th harmonic of Freq2
27)Sine Coefficient of 4th harmonic of Freq2
28)Sine Coefficient of 1th harmonic of Freq3
29)Sine Coefficient of 2th harmonic of Freq3
30)Sine Coefficient of 3th harmonic of Freq3
31)Sine Coefficient of 4th harmonic of Freq3
32)Variance in the time series, after trend subtraction
33)Variance in the time series, after additional subtraction of least-squares fit with 4 harmonics of Freq1
34)Variance in the time series, after additional subtraction of least-squares fit with 4 harmonics of Freq2
35)Variance in the time series, after additional subtraction of least-squares fit with 4 harmonics of Freq3
36)Ratio of the variance after, to the variance before subtraction of least-squares fit with 4 harmonics of Freq1
37)Final variance reduction due to subtraction of all the periodic signals (no units, values close to 1 if the fit is good, close to 0 if the fit is poor)
38)Skewness_time
39)NumberZeroCrossings
40)Ratio of magnitudes/fluxes that are either brighter/larger than or fainter/smaller than the mean magnitude/flux
41)P-value of F-test on variance difference due to subtraction of linear trend (probability)
42)P-value of F-test on variance difference due to subtraction of fit with 4 harmonics of Freq1 (probability) 
43)P-value of F-test on variance difference due to subtraction of fit with 4 harmonics of Freq2 (probability) 
44)P-value of F-test on variance difference due to subtraction of fit with 4 harmonics of Freq3 (probability)