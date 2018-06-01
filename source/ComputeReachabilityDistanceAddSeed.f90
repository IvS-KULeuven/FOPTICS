subroutine ComputeReachabilityDistanceAddSeed(iobj)

use foptics_module
implicit real(8) (a-h,o-z) 
     
do k = 1, NumberPerturbations ! loop over the number of attribute perturbations
 iseed = NumberObjectsSeedList

 do i = 1, NumberObjectsEpsilon ! loop over the number of objects in the epsilon neighborhood
  if(ObjectFlag(ObjectIndexInEpsilon(i)) /= 0) cycle ! Skip the object if it was processed before
  ReachabilityDistanceTemp = max(CoreReachabilityDistance(iobj,k),EpsilonDistances(i,k)) ! Compute reachability distance 

  if(ReachabilityDistance(ObjectIndexInEpsilon(i),k) == DistanceUndefined) then ! if current reachability distance is undefined, update it and add object to seed list        
   iseed = iseed + 1 
   ReachabilityDistance(ObjectIndexInEpsilon(i),k) = ReachabilityDistanceTemp
   SeedList(iseed) = ObjectIndexInEpsilon(i)
   SeedListPositions(ObjectIndexInEpsilon(i)) = iseed
   ReachabilityDistanceSeed(iseed,k) = ReachabilityDistanceTemp          
  elseif(ReachabilityDistanceTemp < ReachabilityDistance(ObjectIndexInEpsilon(i),k)) then ! update it if the new reachability distance is smaller than the current one (object already in seed list)
   ReachabilityDistance(ObjectIndexInEpsilon(i),k) = ReachabilityDistanceTemp
   ReachabilityDistanceSeed(SeedListPositions(ObjectIndexInEpsilon(i)),k) = ReachabilityDistanceTemp
  endif
 enddo
enddo 
      
NumberObjectsSeedList = iseed

end