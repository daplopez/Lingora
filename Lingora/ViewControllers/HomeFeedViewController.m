//
//  HomeFeedViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/6/22.
//

#import "HomeFeedViewController.h"
#import "SceneDelegate.h"
#import "Parse/Parse.h"

@interface HomeFeedViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nativeLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLanguageLabel;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUserProperties];
}


// Retrieve the current user's properties
- (void)setUserProperties {
    PFUser *curUser = [PFUser currentUser];
    
    self.nameLabel.text = curUser[@"fullName"];
    self.nativeLanguageLabel.text = curUser[@"nativeLanguage"];
    self.targetLanguageLabel.text = curUser[@"targetLanguage"];
}


- (IBAction)didTapLogout:(id)sender {
    
    // Logout current user
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    // Return to Login screen
    //[self dismissViewControllerAnimated:YES completion:nil];
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeVC"];
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
