//
//  ProfileViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/8/22.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "Post.h"
#import "Parse/Parse.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nativeLangugaeLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLanguageLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSArray *posts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self getUserData];
    
    [self queryForPosts];
    
    [self.tableView reloadData];
}


- (void)getUserData {
    PFUser *user = [PFUser currentUser];
    
    self.nameLabel.text = user[@"fullName"];
    self.nativeLangugaeLabel.text = user[@"nativeLanguage"];
    self.targetLanguageLabel.text = user[@"targetLanguage"];
}


- (void)queryForPosts {
    
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    Post *post = self.posts[indexPath.row];
    cell.postTextLabel.text = post[@"postText"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
