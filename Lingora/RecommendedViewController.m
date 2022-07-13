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

@interface RecommendedViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nativeLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLanguageLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RecommendedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (IBAction)didTapPosts:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
}


@end
