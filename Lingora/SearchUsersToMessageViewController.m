//
//  SearchUsersToMessageViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/25/22.
//

#import "SearchUsersToMessageViewController.h"
#import "ChatUserSearchTableViewCell.h"
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
    
    [self queryForUsers];
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
            self.users = [[NSArray alloc] initWithArray:users];
            [self setUpView];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)setUpView {
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.filteredData = self.users;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatUserSearchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatSearchCell" forIndexPath:indexPath];
    cell.profilePicture.file = self.filteredData[indexPath.row][@"image"];
    cell.nameLabel.text = self.filteredData[indexPath.row][@"fullName"];
    cell.usernameLabel.text = self.filteredData[indexPath.row][@"username"];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
