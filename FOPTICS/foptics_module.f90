module foptics_module

!!!!!!!!!!!!!!!! Input/Output !!!!!!!!!!!!!!!!!!!

character(200) InputDirectory, OutputFile
integer NumberPerturbations

!!!!!!!!!!!!!!! Objects & attributes !!!!!!!!!!!!

integer NumberObjects, NumberAttributes
integer, allocatable :: ObjectOrder(:)
real(8), allocatable :: Attributes(:,:,:)
character(100), allocatable :: ObjectID(:)

!!!!!!!!!!!!!!! Optics part !!!!!!!!!!!!

integer, allocatable :: SeedList(:), SeedListPositions(:), ObjectFlag(:), ObjectIndexInEpsilon(:), ObjectOrderIndex(:)
real(8), allocatable :: ReachabilityDistanceSeed(:,:), ReachabilityDistance(:,:), CoreReachabilityDistance(:,:), MinimumMeanReachabilityDistance(:), &
                        MeanReachabilityDistance(:), EpsilonDistances(:,:)
real(8) DistanceUndefined
integer NumberObjectsSeedList, NumberObjectsProcessed, MinimumNumberPointsEpsilon, NumberObjectsEpsilon


end module