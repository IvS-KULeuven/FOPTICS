module AttributeTransformation_Module

integer number_LightCurves, NumberFrequencies, NumberHarmonics, NumberProbabilityValues, NumberLightCurveParameters, NumberAttributes

real(8), allocatable :: LightCurveParameters(:,:), Attributes(:,:), ProbabilityValues(:,:)

character(500), allocatable :: LightCurveFiles(:)

end module