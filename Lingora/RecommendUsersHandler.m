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


- (double)getUserScore:(PFUser *)user {
    double finalScore = ([self getProficiencyScoreFromUser:user] + [self getInterestsScoreFromUser:user]) * [self getLocationScoreFromUser:user];
    return finalScore;
}



- (double)getLocationScoreFromUser: (PFUser *)user {
        double distance = [self getDistanceFromUser:user];
       
        /* Reccomendations are weighted the most heavily on proximity;
        the smaller the distance the better.
        So to get a score for location, divide 1 over the distance
        and multiply by 100 - incase the user's distance is multiple
        miles then we don't want the number to be too small */
        double score = (1 / distance) * 100;
        
        return score;
}


- (double)getProficiencyScoreFromUser: (PFUser *)user {
    // handle cases for no native language speakers near you
    // create tests
    NSString *proficiency = user[@"proficiencyLevel"];
    double score = 1.5;
    if ([proficiency isEqualToString:PFUser.currentUser[@"proficiencyLevel"]]) {
        score = 3;
    }
    return  score;
}


- (double)getInterestsScoreFromUser:(PFUser *)user {
    double score = 0;
    // interest score is determined by how many ineterests overlap between two users
    NSArray *userInterests = [[NSArray alloc] initWithArray:user[@"interests"]];
    NSArray *curUserInterests = [[NSArray alloc] initWithArray:PFUser.currentUser[@"interests"]];
    for (int interest = 0; interest < curUserInterests.count; interest++) {
        NSString *curInterest = curUserInterests[interest];
        if ([userInterests containsObject:curInterest]) {
            score += 1;
        }
    }
    return score;
}



@end
