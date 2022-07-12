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
#import "Parse/PFImageView.h"

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource>
// current user info
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nativeLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLanguageLabel;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *posts;
@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self createRefreshControl];
    [self setUserProperties];
    [self queryForUserPosts];
    [self.tableView reloadData];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
}

 

- (void)onTimer {
    [self setUserProperties];
    [self queryForUserPosts];
    [self.tableView reloadData];
}


// Retrieve the current user's properties
- (void)setUserProperties {
    PFUser *curUser = [PFUser currentUser];
    
    self.nameLabel.text = curUser[@"fullName"];
    self.nativeLanguageLabel.text = curUser[@"nativeLanguage"];
    self.targetLanguageLabel.text = curUser[@"targetLanguage"];
    if (curUser[@"image"]) {
        self.profilePicture.file = curUser[@"image"];
        [self.profilePicture loadInBackground];
    }
    
}


- (void)createRefreshControl {
    // refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(queryForUserPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
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
    [self.refreshControl endRefreshing];
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
    if (post.author[@"image"] != nil) {
        cell.postProfilePicture.file = post.author[@"image"];
        [cell.postProfilePicture loadInBackground];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}


- (IBAction)didTapPostCell:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
}

@end

