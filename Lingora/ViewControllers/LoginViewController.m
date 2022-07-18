//
//  LoginViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/5/22.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self assignDelegates];
}


- (void)assignDelegates {
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
}

- (IBAction)didTapBack:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeVC"];
}

- (IBAction)didTapLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        [self emptyFieldAlert];
    }
        
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            // display view controller that needs to shown after successful login
            SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
        }
    }];
}

- (void)emptyFieldAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Required field cannot be empty" preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"Text field was dismissed by the delegate");
    [textField resignFirstResponder];
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
