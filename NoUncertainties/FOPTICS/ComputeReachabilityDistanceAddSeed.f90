subroutine ComputeReachabilityDistanceAddSeed(iobj)

use foptics_module
implicit real(8) (a-h,o-z) 
     
do k = 1, NumberPerturbations ! loop over the number of attribute perturbations
 iseed = NumberObjectsSeedList

 do i = 1, NumberObjectsEpsilon ! loop over the number of objects in the epsilon neighborhood
  if(ObjectFlag(ObjectIndexInEpsilon(i)) /= 0) cycle ! Skip the object if it was processed before
  ReachabilityDistanceTemp = max(CoreReachabilityDistance(iobj,k),EpsilonDistances(i,k)) ! Compute reachability distance 

  if(ReachabilityDistance(ObjectIndexInEpsilon(i),k) == DistanceUndefined) then ! if current reachability distance is undefined, update it and add object to seed list        
   iseed = iseed + 1 ! Get a position in the seed list
   ReachabilityDistance(ObjectIndexInEpsilon(i),k) = ReachabilityDistanceTemp ! Assing a point its reachability distance in the original list if it has been previously undefined
   SeedList(iseed) = ObjectIndexInEpsilon(i)  ! Keep object's index in the actual epsilon neighborhood (=object's position in the actual epsilon neighborhood)
   SeedListPositions(ObjectIndexInEpsilon(i)) = iseed ! Object's position in the seed list
   ReachabilityDistanceSeed(iseed,k) = ReachabilityDistanceTemp ! Reachability distance in the seed list          
  elseif(ReachabilityDistanceTemp < ReachabilityDistance(ObjectIndexInEpsilon(i),k)) then ! update it if the new reachability distance is smaller than the current one (object already in seed list)
   ReachabilityDistance(ObjectIndexInEpsilon(i),k) = ReachabilityDistanceTemp
   ReachabilityDistanceSeed(SeedListPositions(ObjectIndexInEpsilon(i)),k) = ReachabilityDistanceTemp
  endif
 enddo
enddo 
      
NumberObjectsSeedList = iseed

end