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

iii = 0
do i = 1, NumberObjects ! Loop over the number of objects
 if(ObjectFlag(i) == 0) then ! Process objects that are not yet processed (ObjectFlag = 0)
  call ComputeEpsilonCoreDistance(i) ! Determine Epsilon neighborhood and compute epsilon neighborhood and core distances
  ObjectFlag(i) = 1 ! The object has been processed, so flag it accordingly
  NumberObjectsProcessed = NumberObjectsProcessed + 1 ! Increase counter for number of processed objects
  ObjectOrderIndex(NumberObjectsProcessed) = i ! update index array to keep track of the correct ordering of the objects (this array keeps order in which objects are being processed)
  call ComputeReachabilityDistanceAddSeed(i) ! call ComputeReachabilityDistanceAddSeed routine to iteratively collect the direct density-reachable objects with respect to epsilon (eps) and MinPts (MinimumNumberPointsEpsilon). This routine computes reachability distances  
  iii = iii + 1
  write(*,"('object=',i6.6,'  IndexPosition=000000','  MinMeanDr=0.00000000','  CoreDistance=',f10.8)") iii, CoreReachabilityDistance(1,1)
  do while(NumberObjectsSeedList /= 0) ! Loop over seed list (objects with smallest reachability distance are treated first). For each object, the epsilon neighborhood and core distance are determined
   iii = iii + 1
   MeanReachabilityDistance(1:NumberObjectsSeedList) = 0.d0 ! Initialize mean reachability distance array
      
   do j = 1, NumberPerturbations ! loop over number of perturbations 
    MeanReachabilityDistance(1:NumberObjectsSeedList) = MeanReachabilityDistance(1:NumberObjectsSeedList) + ReachabilityDistanceSeed(1:NumberObjectsSeedList,j)
   enddo
   MeanReachabilityDistance(1:NumberObjectsSeedList) = MeanReachabilityDistance(1:NumberObjectsSeedList)/dfloat(NumberPerturbations) ! Mean reachability distance for each of the objects, where mean is taken over number of perturbations
           
   MeanReachibilityDistanceLocation = minloc(MeanReachabilityDistance(1:NumberObjectsSeedList),1) ! find minimum mean reachability distance among all objects in the seed list and keep its array index
          
   IndexPosition = SeedList(MeanReachibilityDistanceLocation) ! position index of the minimum mean reachability distance within the epsilon neighborhood (counting includes the core point itself which means that IndexPosition is the position of the point within the original list of ALL objects)
   MinimumMeanReachabilityDistance(IndexPosition) = MeanReachabilityDistance(MeanReachibilityDistanceLocation) ! Get the value of minimum mean reachability distance into an array. It gets index position which is equal to the one within the epsilon neighborhood
      
   call ComputeEpsilonCoreDistance(IndexPosition) ! Compute epsilon neighborhood and core distance for the point with the smallest reachability distance from the current core point
   write(*,"('object=',i6.6,'  IndexPosition=',i6.6,'  MinMeanDr=',f10.8,'  CoreDistance=',f10.8)") iii, IndexPosition, MinimumMeanReachabilityDistance(IndexPosition), CoreReachabilityDistance(IndexPosition,1)
   
   ObjectFlag(IndexPosition) = 1 ! Object is now processed           
   NumberObjectsProcessed = NumberObjectsProcessed + 1 ! Increase counter for number of processed objects             
!   write(*,*) NumberObjectsProcessed, NumberObjectsEpsilon, NumberObjectsSeedList
   ObjectOrderIndex(NumberObjectsProcessed) = IndexPosition ! update index array to keep track of the correct ordering of the objects (this array keeps order in which objects are being processed)

! Remove treated object from seed list (update seedlist, list with reachability distances and list with seedlist positions). Removing objects from list is done using 
! switching (except if it is the last one). The object switches place with the last one and can then easily be removed by reducing NSEED with one (without requiring 
! copying of large parts of arrays, too time consuming).             
   
   if(MeanReachibilityDistanceLocation < NumberObjectsSeedList) then ! condition for the last object - the block gets executed for any object but the last one. This is because the last object is already in the correct position
    IndexPositionTemp = SeedList(MeanReachibilityDistanceLocation) ! Index position of the object in the list of all objects (same as IndexPosition)
    TempDistances(1:NumberPerturbations) = ReachabilityDistanceSeed(MeanReachibilityDistanceLocation,1:NumberPerturbations) ! Object's distance in the seed list
            
    tmpn = SeedList(NumberObjectsSeedList) ! Position index of the last object in the original list 
    tmpm = SeedList(MeanReachibilityDistanceLocation) ! Position index of the point in question in the original list
            
    SeedList(MeanReachibilityDistanceLocation) = SeedList(NumberObjectsSeedList) ! Swap indicies: last object gets index of the point in question (=last object will be moved to the position of the one in question)
    SeedList(NumberObjectsSeedList) = IndexPositionTemp ! Swap indicies: object in question gets index of the last point (=object in question will be moved to the position of the last one)
            
    ReachabilityDistanceSeed(MeanReachibilityDistanceLocation,1:NumberPerturbations) = ReachabilityDistanceSeed(NumberObjectsSeedList,1:NumberPerturbations) ! The same for distances: they are swapped
    ReachabilityDistanceSeed(NumberObjectsSeedList,1:NumberPerturbations) = TempDistances ! The same for distances: they are swapped 
                        
    IndexPositionTemp = SeedListPositions(tmpm) ! The same for position indicies in the SeedList
            
    SeedListPositions(tmpm) = SeedListPositions(tmpn) ! Last point moves to the position of the one in question
    SeedListPositions(tmpn) = IndexPositionTemp ! Point in question becomes last one
   endif
  
   NumberObjectsSeedList = NumberObjectsSeedList - 1 ! Update number of objects in seed list (will simply exclude the processed point which has moved to the end of the list)

! if core-distance is not undefined (the object is a core-object): call ComputeReachabilityDistanceAddSeed routine again to collect the direct density-reachable objects 
! with respect to epsilon (eps) and MinPts (NP). This routine computes or updates the reachability distances               

   call ComputeReachabilityDistanceAddSeed(IndexPosition)
    
  enddo

 endif

enddo

deallocate(TempDistances)
end