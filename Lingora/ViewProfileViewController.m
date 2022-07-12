//
//  ViewProfileViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/11/22.
//

#import "ViewProfileViewController.h"
#import "SceneDelegate.h"

@interface ViewProfileViewController ()

@end

@implementation ViewProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)didTapBack:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeFeed"];
}

@end
