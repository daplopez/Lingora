//
//  RecommendedViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/11/22.
//

#import "RecommendedViewController.h"
#import "Parse/PFImageView.h"
#import "Parse/Parse.h"
#import "HomeFeedViewController.h"
#import "SceneDelegate.h"
#import "RecommendedTableViewCell.h"
#import "ViewProfileViewController.h"
#import "RecommendUsersHandler.h"

@interface RecommendedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nativeLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLanguageLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *recommendedUsers;
@property (strong, nonatomic) NSMutableArray *userScores;
@property (strong, nonatomic) RecommendUsersHandler *recommendationHandler;

@end

@implementation RecommendedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDelegates];
    [self getUserData];
    [self queryForUsers];
    [self.tableView reloadData];
    
}

- (void)setDelegates {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.recommendationHandler = [[RecommendUsersHandler alloc] init];
}


- (void)getUserData {
    PFUser *curUser = [PFUser currentUser];
    self.nameLabel.text = curUser[@"fullName"];
    self.nativeLanguageLabel.text = curUser[@"nativeLanguage"];
    self.targetLanguageLabel.text = curUser[@"targetLanguage"];
    if (curUser[@"image"] != nil) {
        self.profilePicture.file = curUser[@"image"];
        [self.profilePicture loadInBackground];
    }
}


- (void)queryForUsers {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" notEqualTo:PFUser.currentUser.username];
    [query whereKey:@"nativeLanguage" equalTo:PFUser.currentUser[@"targetLanguage"]];
    [query whereKey:@"targetLanguage" equalTo:PFUser.currentUser[@"nativeLanguage"]];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            NSLog(@"Successfully got users");
            NSArray *usersFromQuery = [[NSArray alloc] initWithArray:users];
            self.recommendedUsers = [NSArray arrayWithArray:users];
            [self getUserScores];
            self.recommendedUsers = [usersFromQuery sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull user1, id  _Nonnull user2) {
                // get rid of array, do calculations here
                double score1 = [self.recommendationHandler getUserScore:user1];
                double score2 = [self.recommendationHandler getUserScore:user2];
                if (score1 > score2) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                if (score1 < score2) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommendedCell"];
    PFUser *user = self.recommendedUsers[indexPath.row];
    cell.profilePicture.file = user[@"image"];
    [cell.profilePicture loadInBackground];
    cell.nameLabel.text = user[@"fullName"];
    cell.nativeLanguageLabel.text = user[@"nativeLanguage"];
    cell.targetLanguageLabel.text = user[@"targetLanguage"];
    cell.proficiencyLevel.text = user[@"proficiencyLevel"];
    double distance = [self getDistanceFromUser:user];
    distance = distance / 1609.34;
    NSString *distanceString = [NSString stringWithFormat:@"%.2f", distance];
    distanceString = [distanceString stringByAppendingString:@" miles"];
    cell.distanceFromUser.text = distanceString;
    return cell;
}


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

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendedUsers.count;
}


- (IBAction)didTapPosts:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"RecToProfile"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        PFUser *dataToPass = self.recommendedUsers[indexPath.row];
        NSLog(@"\n%@\n", dataToPass);
        ViewProfileViewController *profileVC = (ViewProfileViewController *) [segue destinationViewController];
        profileVC.user = dataToPass;
    }
}


@end
