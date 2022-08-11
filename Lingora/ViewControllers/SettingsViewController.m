//
//  SettingsViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 8/11/22.
//

#import "SettingsViewController.h"
#import "Parse/Parse.h"

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



@end
