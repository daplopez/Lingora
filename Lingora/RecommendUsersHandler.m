//
//  RecommendUsersHandler.m
//  Lingora
//
//  Created by Daphne Lopez on 8/3/22.
//

#import "RecommendUsersHandler.h"

@interface RecommendUsersHandler()

@property (strong, nonatomic) NSArray *recommendedUsers;
@property (strong, nonatomic) NSMutableArray *userScores;

@end

@implementation RecommendUsersHandler


- (double)getDistanceFromUser:(PFUser *)user {
    PFGeoPoint *start = PFUser.currentUser[@"location"];
    PFGeoPoint *end = user[@"location"];
    CLLocation *startLoc = [[CLLocation alloc] initWithLatitude:start.latitude longitude:start.longitude];
    CLLocation *endLoc = [[CLLocation alloc] initWithLatitude:end.latitude longitude:end.longitude];
    CLLocationDistance distance = [startLoc distanceFromLocation:endLoc];
    return distance;
}


- (void)getUserScores {
    self.userScores = [[NSMutableArray alloc] initWithCapacity:self.recommendedUsers.count];
    [self getLocationScore];
    [self getProficiencyScore];
    [self getInterestsScore];
}



- (void)getLocationScore {
    for (int i = 0; i < self.recommendedUsers.count; i++) {
        PFUser *user = self.recommendedUsers[i];
        double distance = [self getDistanceFromUser:user];
        // equation for finding score
        double score = 0;
        if (distance <= 5) {
            score = 5;
        } else if (distance <= 10) {
            score = 4;
        } else if (distance <= 20) {
            score = 3;
        } else if (distance <= 30) {
            score = 2;
        } else if (distance <= 50) {
            score = 1;
        } else if (distance <= 100) {
            score = 0.5;
        }
        [self.userScores insertObject:[NSNumber numberWithDouble:score] atIndex:i];
    }
}


- (void)getProficiencyScore {
    // handle cases for no native language speakers near you
    // create tests
    for (int i = 0; i < self.recommendedUsers.count; i++) {
        PFUser *user = self.recommendedUsers[i];
        NSString *proficiency = user[@"proficiencyLevel"];
        double score = 1.5;
        if ([proficiency isEqualToString:PFUser.currentUser[@"proficiencyLevel"]]) {
            score = 3;
        }
        double newScore = [self.userScores[i] doubleValue] + score;
        [self.userScores replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:newScore]];
    }
}


- (void)getInterestsScore {
    double score = 0;
    for (int i = 0; i < self.recommendedUsers.count; i++) {
        PFUser *user = self.recommendedUsers[i];
        NSArray *userInterests = [[NSArray alloc] initWithArray:user[@"interests"]];
        NSArray *curUserInterests = [[NSArray alloc] initWithArray:PFUser.currentUser[@"interests"]];
        for (int interest = 0; interest < curUserInterests.count; interest++) {
            NSString *curInterest = curUserInterests[interest];
            if ([userInterests containsObject:curInterest]) {
                score += 1;
            }
        }
        double newScore = [self.userScores[i] doubleValue] + score;
        [self.userScores replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:newScore]];
    }
}



@end
