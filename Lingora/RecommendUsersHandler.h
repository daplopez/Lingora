//
//  RecommendUsersHandler.h
//  Lingora
//
//  Created by Daphne Lopez on 8/3/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendUsersHandler : NSObject

- (double)getDistanceFromUser:(PFUser *)user;
- (void)getUserScores;
- (void)getLocationScore;
- (void)getProficiencyScore;
- (void)getInterestsScore;

@end

NS_ASSUME_NONNULL_END
