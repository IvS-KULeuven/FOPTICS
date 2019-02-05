subroutine AttributeTransformation_Output

use AttributeTransformation_Module
implicit real(8) (a-h,o-z)

do i = 1, number_LightCurves ! Loop over the number of light curves
 write(1,"(a,1000(1x,f16.8))") trim(adjustl(LightCurveFiles(i))), (Attributes(i,j), j = 1, NumberAttributes), (ProbabilityValues(i,j), j = 1, NumberProbabilityValues)
enddo
close(1)

end