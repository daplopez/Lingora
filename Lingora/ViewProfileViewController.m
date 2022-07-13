//
//  ViewProfileViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/11/22.
//

#import "ViewProfileViewController.h"
#import "SceneDelegate.h"
#import "Parse/PFImageView.h"

@interface ViewProfileViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nativeLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLanguageLabel;

@end

@implementation ViewProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.profilePicture.file = self.user[@"image"];
    [self.profilePicture loadInBackground];
    self.nameLabel.text = self.user[@"fullName"];
    self.nativeLanguageLabel.text = self.user[@"nativeLanguage"];
    self.targetLanguageLabel.text = self.user[@"targetLanguage"];
}


- (IBAction)didTapBack:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
}

@end
