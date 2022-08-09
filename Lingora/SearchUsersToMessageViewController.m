//
//  SearchUsersToMessageViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/25/22.
//

#import "SearchUsersToMessageViewController.h"
#import "ChatUserSearchTableViewCell.h"
#import "DirectMessageViewController.h"
#import "Parse/Parse.h"

@interface SearchUsersToMessageViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) NSArray *filteredData;
@end

@implementation SearchUsersToMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDelegates];
    [self queryForUsers];
}

- (void)queryForUsers {
    PFQuery *oppositeQuery = [PFQuery queryWithClassName:@"_User"];
    [oppositeQuery whereKey:@"username" notEqualTo:PFUser.currentUser.username];
    [oppositeQuery whereKey:@"nativeLanguage" equalTo:PFUser.currentUser[@"targetLanguage"]];
    [oppositeQuery whereKey:@"targetLanguage" equalTo:PFUser.currentUser[@"nativeLanguage"]];
    
    PFQuery *sameTargetQuery = [PFQuery queryWithClassName:@"_User"];
    [sameTargetQuery whereKey:@"username" notEqualTo:PFUser.currentUser.username];
    [sameTargetQuery whereKey:@"targetLanguage" equalTo:PFUser.currentUser[@"targetLanguage"]];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[[NSArray alloc] initWithObjects:oppositeQuery, sameTargetQuery, nil]];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];

    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            NSLog(@"Successfully got users");
            self.users = [[NSArray alloc] initWithArray:users];
            self.filteredData = [[NSArray alloc] initWithArray:users];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)setDelegates {
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatUserSearchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatSearchCell" forIndexPath:indexPath];
    cell.profilePicture.file = self.filteredData[indexPath.row][@"image"];
    [cell.profilePicture loadInBackground];
    cell.nameLabel.text = self.filteredData[indexPath.row][@"fullName"];
    cell.usernameLabel.text = self.filteredData[indexPath.row][@"username"];
    return cell;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username CONTAINS[cd] %@", searchText];
        self.filteredData = [self.users filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredData = self.users;
    }
    [self.tableView reloadData];
}


#pragma mark - Navigation

// Segue to direct message vc, passing the user selected
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SearchToDM"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        PFUser *dataToPass = self.filteredData[indexPath.row];
        DirectMessageViewController *messageVC = (DirectMessageViewController *) [segue destinationViewController];
        messageVC.user = dataToPass;
    }
}

@end
