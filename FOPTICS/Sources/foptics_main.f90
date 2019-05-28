use foptics_module
implicit real(8) (a-h,o-z)

call foptics_input ! subroutine to get all the input

call optics ! run the optics algorithm

deallocate(Attributes,SeedList,SeedListPositions,ReachabilityDistanceSeed,ObjectFlag,ReachabilityDistance,CoreReachabilityDistance,MeanReachabilityDistance, &
           EpsilonDistances,ObjectIndexInEpsilon)

ReachibilityDistanceMinimum = minval(MinimumMeanReachabilityDistance) ! Minimum value of all the reachability distances
ReachibilityDistanceMaximum = maxval(MinimumMeanReachabilityDistance) ! Maximum value of all the reachability distances
Denominator = ReachibilityDistanceMaximum - ReachibilityDistanceMinimum ! Denominator to be used later 

open(10,file=trim(adjustl(OutputFile)))
do i = 1, NumberObjects
 indextemp = ObjectOrderIndex(i)
! idtemp = ObjectOrder(indextemp)
! write(10,"(i7,5x,i7,5x,a,5x,f17.12,5x,f10.8)") i, idtemp, trim(adjustl(ObjectID(idtemp))), MinimumMeanReachabilityDistance(indextemp), (MinimumMeanReachabilityDistance(indextemp) -  ReachibilityDistanceMinimum)/Denominator
 write(10,"(i7,5x,i7,5x,a,5x,f17.12,5x,f10.8)") i, indextemp, trim(adjustl(ObjectID(indextemp))), MinimumMeanReachabilityDistance(indextemp), (MinimumMeanReachabilityDistance(indextemp) -  ReachibilityDistanceMinimum)/Denominator
enddo
close(10)

deallocate(ObjectID,ObjectOrder,MinimumMeanReachabilityDistance,ObjectOrderIndex)

end
