//
//  Location.h
//  Lingora
//
//  Created by Daphne Lopez on 7/15/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Location : PFObject <PFSubclassing>

@property double latitude;
@property double longitude;
@property (strong, nonatomic) PFUser *author;

+ (void) addUserLocation: ( CLLocation * _Nullable )location withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
