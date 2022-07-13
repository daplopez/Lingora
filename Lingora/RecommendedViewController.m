//
//  RecommendedViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/11/22.
//

#import "RecommendedViewController.h"
#import "Parse/PFImageView.h"
#import "Parse/Parse.h"
#import "HomeFeedViewController.h"
#import "SceneDelegate.h"
#import "RecommendedTableViewCell.h"

@interface RecommendedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nativeLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLanguageLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *recommendedUsers;

@end

@implementation RecommendedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getUserData];
    [self.tableView reloadData];
    
}

- (void)getUserData {
    PFUser *curUser = [PFUser currentUser];
    self.nameLabel.text = curUser[@"fullName"];
    self.nativeLanguageLabel.text = curUser[@"nativeLanguage"];
    self.targetLanguageLabel.text = curUser[@"targetLanguage"];
    if (curUser[@"image"] != nil) {
        self.profilePicture.file = curUser[@"image"];
        [self.profilePicture loadInBackground];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommendedCell"];
    PFUser *user = self.recommendedUsers[indexPath.row];
    cell.profilePicture.file = user[@"image"];
    cell.nameLabel.text = user[@"fullName"];
    cell.nativeLanguageLabel.text = user[@"nativeLanguage"];
    cell.targetLanguageLabel.text = user[@"targetLanguage"];
    cell.proficiencyLevel.text = user[@"proficiency"];
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendedUsers.count;
}


- (IBAction)didTapPosts:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
}
@end
