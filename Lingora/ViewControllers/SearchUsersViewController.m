//
//  SearchUsersViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 8/8/22.
//

#import "SearchUsersViewController.h"
#import "Parse/Parse.h"
#import "UserSearchTableViewCell.h"

@interface SearchUsersViewController () <FilterUserSearchDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *users;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDelegates];
    [self queryForUsers];
}


- (void)setDelegates {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)queryForUsers {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    if (self.interests != nil) {
        [query whereKey:@"interests" containsAllObjectsInArray:self.interests];
    }
    if (self.locationField != nil) {
        double miles = [self.locationField doubleValue];
        [query whereKey:@"location" nearGeoPoint:PFUser.currentUser[@"location"] withinMiles:miles];
    }
    if (self.targetLanguageField != nil) {
        [query whereKey:@"targetLanguage" equalTo:self.targetLanguageField];
    }
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            NSLog(@"Successfully got users");
            self.users = [[NSArray alloc] initWithArray:users];
            NSLog(@"%d", self.users.count);
            NSLog(@"%d", users.count);
            NSLog(@"CHECK");
            //[self setDataToFilterBy];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)sendFiltersBack:(NSString *)language withRange:(NSString *)miles interests:(NSArray *)interests {
    self.interests = interests;
    self.targetLanguageField = language;
    self.locationField = miles;
    [self queryForUsers];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%d", self.users.count);
    NSLog(@"CHECK");
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserSearchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"userSearchCell" forIndexPath:indexPath];
    cell.profilePicture.file = self.users[indexPath.row][@"image"];
    [cell.profilePicture loadInBackground];
    //cell.nameLabel.text = self.filteredData[indexPath.row];
    cell.nameLabel.text = self.users[indexPath.row][@"username"];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FilterUserSearchViewController *filterVC = [segue destinationViewController];
    filterVC.delegate = self;
}

@end
