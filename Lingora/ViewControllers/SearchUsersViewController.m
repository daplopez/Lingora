//
//  SearchUsersViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 8/8/22.
//

#import "SearchUsersViewController.h"
#import "Parse/Parse.h"
#import "UserSearchTableViewCell.h"
#import "ViewProfileViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface SearchUsersViewController () <FilterUserSearchDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) NSArray *users;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredData;

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
    self.searchBar.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

- (void)queryForUsers {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" notEqualTo:PFUser.currentUser.username];
    
    if (self.interests.count != 0) {
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
            self.filteredData = [[NSArray alloc] initWithArray:users];
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
    return self.filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserSearchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"userSearchCell" forIndexPath:indexPath];
    
    cell.profilePicture.file = self.filteredData[indexPath.row][@"image"];
    [cell.profilePicture loadInBackground];
    
    cell.nameLabel.text = self.filteredData[indexPath.row][@"username"];
    
    cell.targetLanguageLabel.text = self.filteredData[indexPath.row][@"targetLanguage"];
    return cell;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username CONTAINS[cd] %@", searchText];
        self.filteredData = [self.users filteredArrayUsingPredicate:predicate];
              
        NSLog(@"%@", self.filteredData);
              
    } else {
        self.filteredData = self.users;
    }
    
    [self.tableView reloadData];
 
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"searchUserToProfile"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        PFUser *dataToPass = self.filteredData[indexPath.row];
        ViewProfileViewController *viewProfileVC = (ViewProfileViewController *) [segue destinationViewController];
        viewProfileVC.user = dataToPass;
    } else {
        FilterUserSearchViewController *filterVC = [segue destinationViewController];
        filterVC.delegate = self;
    }
}


#pragma mark - DZNEmptyDataSet Delegate Methods

//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return [UIImage imageNamed:@"empty_placeholder"];
//}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No users found";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Adjust filters for better results";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


@end
