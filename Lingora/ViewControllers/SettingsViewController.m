//
//  SettingsViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 8/11/22.
//

#import "SettingsViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSwitch];
}

- (void)setSwitch {
    NSNumber *locationAccess = PFUser.currentUser[@"locationAccess"];
    if ([locationAccess isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [self.locationSwitch setOn:NO];
    } else {
        [self.locationSwitch setOn:YES];
    }
}


- (IBAction)didTapLocationSwitch:(id)sender {
    NSNumber *locationAccess = PFUser.currentUser[@"locationAccess"];
    if ([locationAccess isEqualToNumber:[NSNumber numberWithInt:1]]) {
        locationAccess = [NSNumber numberWithInt:0];
        PFUser.currentUser[@"locationAccess"] = [NSNumber numberWithInt:0];
        [PFUser.currentUser saveInBackground];
        [self.locationSwitch setOn:NO];
    } else {
        PFUser.currentUser[@"locationAccess"] = [NSNumber numberWithInt:1];
        [PFUser.currentUser saveInBackground];
        [self.locationSwitch setOn:YES];
    }
}

- (IBAction)didTapLogout:(id)sender {
    // Logout current user
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {}];
    // Return to Login screen
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeVC"];
}

@end
