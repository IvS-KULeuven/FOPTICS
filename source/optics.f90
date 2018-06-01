subroutine optics
use foptics_module
implicit real(8) (a-h,o-z)

real(8), allocatable :: TempDistances(:)
integer tmpn, tmpm

!!!!!!!!!!!!!!!!!!! Array allocations !!!!!!!!!!!!!!!!!!!!!

allocate(SeedList(NumberObjects),SeedListPositions(NumberObjects),ReachabilityDistanceSeed(NumberObjects,NumberPerturbations),ObjectFlag(NumberObjects), &
         ObjectOrderIndex(NumberObjects),ReachabilityDistance(NumberObjects,NumberPerturbations),CoreReachabilityDistance(NumberObjects,NumberPerturbations), &
         MinimumMeanReachabilityDistance(NumberObjects),MeanReachabilityDistance(NumberObjects),TempDistances(NumberPerturbations), &
         EpsilonDistances(NumberObjects,NumberPerturbations),ObjectIndexInEpsilon(NumberObjects))

! initializations (distances are initialized as undefined, where DistanceUndefined is to be specified by the user

SeedList = 0; SeedListPositions = 0; ObjectFlag = 0; ReachabilityDistance = DistanceUndefined; CoreReachabilityDistance = DistanceUndefined ! Arrays
MinimumMeanReachabilityDistance = DistanceUndefined; MeanReachabilityDistance = DistanceUndefined ! Arrays
NumberObjectsSeedList = 0; NumberObjectsProcessed = 0 ! Variables

do i = 1, NumberObjects ! Loop over the number of objects
 if(ObjectFlag(i) == 0) then ! Process objects that are not yet processed (ObjectFlag = 0)
  call ComputeEpsilonCoreDistance(i) ! Determine Epsilon neighborhood and compute core distance
  ObjectFlag(i) = 1 ! The object has been processed, so flag it accordingly
  NumberObjectsProcessed = NumberObjectsProcessed + 1 ! Increase counter for number of processed objects
  ObjectOrderIndex(NumberObjectsProcessed) = i ! update index array to keep track of the correct ordering of the objects
  call ComputeReachabilityDistanceAddSeed(i) ! call ComputeReachabilityDistanceAddSeed routine to iteratively collect the direct density-reachable objects with respect to epsilon (eps) and MinPts (MinimumNumberPointsEpsilon). This routine computes reachability distances  
  do while(NumberObjectsSeedList /= 0) ! Loop over seed list (objects with smallest reachability distance are treated first). For each object, the epsilon neighborhood and core distance are determined
   MeanReachabilityDistance(1:NumberObjectsSeedList) = 0.d0
   
   do j = 1, NumberPerturbations
    MeanReachabilityDistance(1:NumberObjectsSeedList) = MeanReachabilityDistance(1:NumberObjectsSeedList) + ReachabilityDistanceSeed(1:NumberObjectsSeedList,j)
   enddo
   MeanReachabilityDistance(1:NumberObjectsSeedList) = MeanReachabilityDistance(1:NumberObjectsSeedList)/dfloat(NumberPerturbations)
           
   MeanReachibilityDistanceLocation = minloc(MeanReachabilityDistance(1:NumberObjectsSeedList),1)
          
   IndexPosition = SeedList(MeanReachibilityDistanceLocation) 
   MinimumMeanReachabilityDistance(IndexPosition) = MeanReachabilityDistance(MeanReachibilityDistanceLocation)
   
   call ComputeEpsilonCoreDistance(IndexPosition)
   
   ObjectFlag(IndexPosition) = 1 ! Object is now processed           
   NumberObjectsProcessed = NumberObjectsProcessed + 1 ! Increase counter for number of processed objects             
!   write(*,*) NumberObjectsProcessed, NumberObjectsEpsilon
   ObjectOrderIndex(NumberObjectsProcessed) = IndexPosition ! update index array to keep track of the correct ordering of the objects  

! Remove treated object from seed list (update seedlist, list with reachability distances and list with seedlist positions). Removing objects from list is done using 
! switching (except if it is the last one). The object switches place with the last one and can then easily be removed by reducing NSEED with one (without requiring 
! copying of large parts of arrays, too time consuming).             
   
   if(MeanReachibilityDistanceLocation < NumberObjectsSeedList)then
     IndexPositionTemp = SeedList(MeanReachibilityDistanceLocation)
     TempDistances(1:NumberPerturbations) = ReachabilityDistanceSeed(MeanReachibilityDistanceLocation,1:NumberPerturbations)
            
     tmpn = SeedList(NumberObjectsSeedList)
     tmpm = SeedList(MeanReachibilityDistanceLocation)
            
     SeedList(MeanReachibilityDistanceLocation) = SeedList(NumberObjectsSeedList)
     SeedList(NumberObjectsSeedList) = IndexPositionTemp
            
     ReachabilityDistanceSeed(MeanReachibilityDistanceLocation,1:NumberPerturbations) = ReachabilityDistanceSeed(NumberObjectsSeedList,1:NumberPerturbations)
     ReachabilityDistanceSeed(NumberObjectsSeedList,1:NumberPerturbations) = TempDistances
                        
     IndexPositionTemp = SeedListPositions(tmpm)
            
     SeedListPositions(tmpm) = SeedListPositions(tmpn)
     SeedListPositions(tmpn) = IndexPositionTemp
    endif
  
    NumberObjectsSeedList = NumberObjectsSeedList - 1 ! Update number of objects in seed list

! if core-distance is not undefined (the object is a core-object): call ComputeReachabilityDistanceAddSeed routine again to collect the direct density-reachable objects 
! with respect to epsilon (eps) and MinPts (NP). This routine computes or updates the reachability distances               

    call ComputeReachabilityDistanceAddSeed(IndexPosition)
    
  enddo

 endif

enddo

deallocate(TempDistances)
end