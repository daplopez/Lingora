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
    double distance = [self.recommendationHandler getDistanceFromUser:user];
    distance = distance / 1609.34;
    NSString *distanceString = [NSString stringWithFormat:@"%.2f", distance];
    distanceString = [distanceString stringByAppendingString:@" miles"];
    cell.distanceFromUser.text = distanceString;
    return cell;
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
