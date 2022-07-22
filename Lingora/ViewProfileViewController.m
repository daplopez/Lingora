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
#import "PostProfileImagesCollectionViewCell.h"
#import "PostInterestCollectionViewCell.h"

@interface ViewProfileViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nativeLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLanguageLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *interestsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) NSArray *userInterests;
@property (strong, nonatomic) NSArray *userImages;

@end

@implementation ViewProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    [self setUserProperties];
    [self queryUserPosts];
}

- (void)setUpViews {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.interestsCollectionView.delegate = self;
    self.interestsCollectionView.dataSource = self;
    self.imagesCollectionView.delegate = self;
    self.imagesCollectionView.dataSource = self;
}

- (void)setUserProperties {
    self.profilePicture.file = self.user[@"image"];
    [self.profilePicture loadInBackground];
    self.nameLabel.text = self.user[@"fullName"];
    self.nativeLanguageLabel.text = self.user[@"nativeLanguage"];
    self.targetLanguageLabel.text = self.user[@"targetLanguage"];
    self.userInterests = [NSArray arrayWithArray:self.user[@"interests"]];
    self.userImages = [NSArray arrayWithArray:self.user[@"profileCollectionView"]];
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

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.interestsCollectionView]) {
        PostInterestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"postInterestCell" forIndexPath:indexPath];
        NSString *interest = self.userInterests[indexPath.row];
        cell.interestLabel.text = interest;
        return cell;
    } else {
        PostProfileImagesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"postUserImageCell" forIndexPath:indexPath];
        cell.profileImages.file = self.userImages[indexPath.row];
        [cell.profileImages loadInBackground];
        return cell;
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.interestsCollectionView]) {
        return self.userInterests.count;
    } else {
        return self.userImages.count;
    }
}


- (IBAction)didTapBack:(id)sender {
//    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
