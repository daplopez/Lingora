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

- (double)getUserScore:(PFUser *)user;
- (double)getDistanceFromUser:(PFUser *)user;
- (double)getLocationScoreFromUser:(PFUser *)user;
- (double)getProficiencyScoreFromUser:(PFUser *)user;
- (double)getInterestsScoreFromUser:(PFUser *)user;

@end

NS_ASSUME_NONNULL_END
