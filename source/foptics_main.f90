use foptics_module
implicit real(8) (a-h,o-z)

call foptics_input ! subroutine to get all the input

call optics ! run the optics algorithm

deallocate(Attributes,SeedList,SeedListPositions,ReachabilityDistanceSeed,ObjectFlag,ReachabilityDistance,CoreReachabilityDistance,MeanReachabilityDistance, &
           EpsilonDistances,ObjectIndexInEpsilon)

open(10,file=trim(adjustl(OutputFile)))
do i = 1, NumberObjects
 indextemp = ObjectOrderIndex(i)
 idtemp = ObjectOrder(indextemp)
 write(10,"(i7,5x,a,5x,f17.12)") idtemp, trim(adjustl(ObjectID(idtemp))), MinimumMeanReachabilityDistance(indextemp)
enddo

deallocate(ObjectID,ObjectOrder,MinimumMeanReachabilityDistance,ObjectOrderIndex)

end