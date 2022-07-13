//
//  ViewProfileViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/11/22.
//

#import "ViewProfileViewController.h"
#import "SceneDelegate.h"
#import "Parse/PFImageView.h"
#import "PostProfileTableViewCell.h"
#import "Post.h"

@interface ViewProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nativeLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLanguageLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *interestsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation ViewProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setUserProperties];
    [self queryUserPosts];
}


- (void)setUserProperties {
    self.profilePicture.file = self.user[@"image"];
    [self.profilePicture loadInBackground];
    self.nameLabel.text = self.user[@"fullName"];
    self.nativeLanguageLabel.text = self.user[@"nativeLanguage"];
    self.targetLanguageLabel.text = self.user[@"targetLanguage"];
}


- (void)queryUserPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"author" equalTo:self.user];

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
    PostProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostProfileCell"];
    Post *post = self.posts[indexPath.row];
    cell.postTextLabel.text = post[@"postText"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}


- (IBAction)didTapBack:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
}

@end
