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

+ (double)getDistanceFromUser:(PFUser *)user {
    PFGeoPoint *start = PFUser.currentUser[@"location"];
    PFGeoPoint *end = user[@"location"];
    CLLocation *startLoc = [[CLLocation alloc] initWithLatitude:start.latitude longitude:start.longitude];
    CLLocation *endLoc = [[CLLocation alloc] initWithLatitude:end.latitude longitude:end.longitude];
    CLLocationDistance distance = [startLoc distanceFromLocation:endLoc];
    return distance;
}


+ (double)getSimilarityToUser:(PFUser *)user {
    NSArray *curUserRankedInterests = [[NSArray alloc] initWithArray:PFUser.currentUser[@"rankedInterests"]];
    NSArray *otherUserRankedInterests = [[NSArray alloc] initWithArray:user[@"rankedInterests"]];
    double distance = 0.0;
    // Use Euclidean Distance formula to find similarity of interests between users; the
    // smaller the distance the better
    for (int i = 0; i < curUserRankedInterests.count; i++) {
        int diff = [curUserRankedInterests[i] intValue] - [otherUserRankedInterests[i] intValue];
        distance += diff * diff;
    }
    distance = sqrt(distance);
    return distance;
}

+ (double)getUserScore:(PFUser *)user {
    // since location has the most weight, it is multiplied by instead of added
    double finalScore = ([self getProficiencyScoreFromUser:user] + [self getInterestsScoreFromUser:user] + [self getLanguageScoreFromUser:user] + [self getSimilarityToUser:user]) * [self getLocationScoreFromUser:user];
    NSLog(@"%@", user.username);
    NSLog(@"%f", finalScore);
    return finalScore;
}

+ (double)getLocationScoreFromUser:(PFUser *)user {
        double distance = [self getDistanceFromUser:user];
       
        /* Reccomendations are weighted the most heavily on proximity;
        the smaller the distance the better. The further away they are
        from the current user, the less weight that location will have
        So to get a score for location, divide 1 over the distance
        and multiply by 100 - incase the user's distance is multiple
        miles then we don't want the number to be too small */
        double score = (1 / distance) * 100;
        
        return score;
}


+ (double)getLanguageScoreFromUser:(PFUser *)user {
    NSString *nativeLanguage = user[@"nativeLanguage"];
    double score = 1;
    if ([nativeLanguage isEqualToString:PFUser.currentUser[@"targetLanguage"]]) {
        score = 5;
    }
    return score;
}


+ (double)getProficiencyScoreFromUser:(PFUser *)user {
    // handle cases for no native language speakers near you
    // create tests
    NSString *proficiency = user[@"proficiencyLevel"];
    double score = 1.5;
    if ([proficiency isEqualToString:PFUser.currentUser[@"proficiencyLevel"]]) {
        score = 3;
    }
    return  score;
}

+ (double)getInterestsScoreFromUser:(PFUser *)user {
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
