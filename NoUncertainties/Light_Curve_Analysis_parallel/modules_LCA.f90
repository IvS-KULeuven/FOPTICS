module input_output ! Module containing all kinds of input information

character(500) DataDir, OutDir, WorkDir, PhaseDir, AmplDir, LightDir, LogDir, RunName, OutFileMerged
character(500), allocatable :: LightCurveFiles(:), PhasePlotFiles(:), AmplitudeSpectraFiles(:)
integer number_LightCurves

end module

module light_curve ! Module containing relevant information about light curves

integer ndeg ! Polynomial degree for light curve detrending (probably, does not need to be 2, can be anything)
integer NFswitch ! Switch for the Nyquist frequency calculation (0 - Kepler long-cadence, 1 - computed from mean of the inverse time steps)

character(100) LightCurveUnits
real(8), allocatable :: times(:), flux(:), weights(:), Variance(:), flux_detrended(:), BinCenters(:)
real(8) TotalTimeSpan, FrequencyResolution, FluxRawMean, VarianceRaw, FluxDetrendedMean, VarianceDetrended, NyquistFrequency, FrequencyStep
integer ntimes, NumberFrequencies
integer, parameter :: NumberBins = 60

end module 

module lomb_scargle

integer NumberFrequenciesExtract, NumberHarmonics, TwiceNumberHarmonics, NumberBlackListFrequencies

real(8), allocatable :: SS(:), SC(:), SS2(:), SC2(:), F1(:), PS(:), S0N(:), C0N(:), DEN(:), SDFN(:), CDFN(:)
real(8), allocatable :: FrequenciesExtracted(:), FittingCoefficientsPerFrequency(:,:), FrequencyProbability(:), BlackListFrequencies(:)

end module