use AttributeTransformation_Module
implicit real(8) (a-h,o-z)

call AttributeTransformation_Input ! get all necessary input

call AttributeTransformation_Transform ! transform light curve parameters to attributes

call AttributeTransformation_Output ! Save attributes into a file

deallocate(LightCurveFiles,LightCurveParameters,ProbabilityValues,Attributes)

end