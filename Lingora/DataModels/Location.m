//
//  Location.m
//  Lingora
//
//  Created by Daphne Lopez on 7/15/22.
//

#import "Location.h"

@implementation Location

@dynamic latitude;
@dynamic longitude;
@dynamic author;

+ (nonnull NSString *)parseClassName {
    return @"Location";
}

+ (void) addUserLocation:(CLLocation *)location withCompletion:(PFBooleanResultBlock)completion {
    Location *userLocation = [Location new];
    userLocation.author = [PFUser currentUser];
    userLocation.latitude = location.coordinate.latitude;
    userLocation.longitude = location.coordinate.longitude;
    
    [userLocation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        PFUser.currentUser[@"Location"] = userLocation;
        [PFUser.currentUser saveInBackground];
        completion(succeeded, error);
    }];
//    [userLocation saveInBackgroundWithBlock:completion];
    
//    PFUser.currentUser[@"Location"] = userLocation;
//    [PFUser.currentUser saveInBackground];
}

@end
