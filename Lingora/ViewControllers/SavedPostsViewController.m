//
//  SavedPostsViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 8/3/22.
//

#import "SavedPostsViewController.h"
#import "SavedPostsTableViewCell.h"
#import "Parse/Parse.h"
#import "Post.h"

@interface SavedPostsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *savedPosts;
@property (strong, nonatomic) PFUser *user;

@end

@implementation SavedPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDelegates];
    [self queryForCurrentUser];
    
}


-(void)queryForCurrentUser {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:PFUser.currentUser.username];
    [query includeKey:@"savedPosts"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            self.user = users[0];
            NSLog(@"%@", users[0]);
            if (PFUser.currentUser[@"savedPosts"] != nil) {
                NSArray *saved = self.user[@"savedPosts"];
                self.savedPosts = [[NSMutableArray alloc] initWithArray:saved];
            } else {
                self.savedPosts = [[NSMutableArray alloc] init];
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)setDelegates {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SavedPostsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"savedPostCell"];
    Post *post = self.savedPosts[indexPath.row];
    NSLog(@"%@", post.postText);
    cell.postTextLabel.text = post.postText;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%d", self.savedPosts.count);
    return self.savedPosts.count;
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
