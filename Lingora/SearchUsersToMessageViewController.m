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
@property (strong, nonatomic) NSMutableArray *dataToFilterBy;
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
            [self setDataToFilterBy];
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


- (void)setDataToFilterBy {
    self.dataToFilterBy = [[NSMutableArray alloc] initWithCapacity:self.users.count];
    for (int i = 0; i < self.users.count; i++) {
        NSString *name = self.users[i][@"fullName"];
        NSLog(@"\nHELLLOOOOO\n");
        NSLog(@"%@", name);
        [self.dataToFilterBy addObject:name];
        NSLog(@"%@", self.dataToFilterBy[i]);
    }
    self.filteredData = [[NSArray alloc] initWithArray:self.dataToFilterBy];
    NSLog(@"%@", self.dataToFilterBy[0]);
    NSLog(@"%@", self.filteredData[0]);
    NSLog(@"\n");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatUserSearchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatSearchCell" forIndexPath:indexPath];
    cell.profilePicture.file = self.users[indexPath.row][@"image"];
    [cell.profilePicture loadInBackground];
    cell.nameLabel.text = self.filteredData[indexPath.row];
    cell.usernameLabel.text = self.users[indexPath.row][@"username"];
    return cell;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
                return [evaluatedObject containsString:searchText];
            }];
            self.filteredData = [self.dataToFilterBy filteredArrayUsingPredicate:predicate];
            
            NSLog(@"%@", self.dataToFilterBy);
            
        }
        else {
            self.filteredData = self.dataToFilterBy;
        }
        
        [self.tableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SearchToDM"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        PFUser *dataToPass = self.users[indexPath.row];
        NSLog(@"\n%@\n", dataToPass);
        DirectMessageViewController *messageVC = (DirectMessageViewController *) [segue destinationViewController];
        messageVC.user = dataToPass;
    }
}

@end
