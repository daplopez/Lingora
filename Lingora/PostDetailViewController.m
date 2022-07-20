//
//  PostDetailViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/13/22.
//

#import "PostDetailViewController.h"
#import "Parse/PFImageView.h"
#import "DateTools/DateTools.h"
#import "ViewProfileViewController.h"
#import "SceneDelegate.h"

@interface PostDetailViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@end

@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPostProperties];
}

- (void)setPostProperties {
    PFUser *user = self.post.author;
    self.profilePicture.file = user[@"image"];
    [self.profilePicture loadInBackground];
    self.nameLabel.text = user[@"fullName"];
    self.usernameLabel.text = user.username;
    self.postTextLabel.text = self.post.postText;
    self.languageLabel.text = user[@"nativeLanguage"];
    self.timestampLabel.text = [self.post.createdAt shortTimeAgoSinceNow];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"PostProfile"]) {
        PFUser *dataToPass = self.post[@"author"];
        ViewProfileViewController *viewProfileVC = (ViewProfileViewController *) [segue destinationViewController];
        viewProfileVC.user = dataToPass;
    }
}

- (IBAction)didTapProfilePicture:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
}


@end
