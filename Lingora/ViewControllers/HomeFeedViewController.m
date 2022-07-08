//
//  HomeFeedViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/6/22.
//

#import "HomeFeedViewController.h"
#import "SceneDelegate.h"
#import "Parse/Parse.h"
#import "PostTableViewCell.h"
#import "Post.h"

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource>
// current user info
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nativeLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLanguageLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *posts;
@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self setUserProperties];
}

// Retrieve the current user's properties
- (void)setUserProperties {
    PFUser *curUser = [PFUser currentUser];
    
    self.nameLabel.text = curUser[@"fullName"];
    self.nativeLanguageLabel.text = curUser[@"nativeLanguage"];
    self.targetLanguageLabel.text = curUser[@"targetLanguage"];
}


- (void)queryForUserPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSLog(@"Successfully got posts");
            self.posts = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (IBAction)didTapLogout:(id)sender {
    // Logout current user
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {}];
    // Return to Login screen
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeVC"];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.posts[indexPath.row];
    cell.postNameLabel.text = post.author[@"fullName"];
    cell.postUsernameLabel.text = post.author.username;
    cell.postTextLabel.text = post[@"postText"];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
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

