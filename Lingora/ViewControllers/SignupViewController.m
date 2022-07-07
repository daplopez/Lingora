//
//  SignupViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/6/22.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"

@interface SignupViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *nativeLanguageField;
@property (weak, nonatomic) IBOutlet UITextField *targetLanguageField;
@property (weak, nonatomic) IBOutlet UITextField *proficiencyLevelField;
@property (strong, nonatomic) NSArray *languages;
@property (weak, nonatomic) IBOutlet UIPickerView *nativeLanguagePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *targetLanguagePickerView;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nativeLanguagePickerView.delegate = self;
    self.nativeLanguagePickerView.dataSource = self;
    self.targetLanguagePickerView.delegate = self;
    self.targetLanguagePickerView.dataSource = self;
    
    self.nativeLanguageField.delegate = self;
    self.nativeLanguageField.inputView = self.nativeLanguagePickerView;
    self.targetLanguageField.delegate = self;
    self.targetLanguageField.inputView = self.targetLanguagePickerView;
    
    [self.nativeLanguagePickerView setHidden:YES];
    [self.targetLanguagePickerView setHidden:YES];
    
    self.languages = [[NSArray alloc] initWithObjects:@"English", @"Spanish", nil];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.nativeLanguageField]) {
        [self.nativeLanguagePickerView setHidden:NO];
    } else {
        [self.targetLanguagePickerView setHidden:NO];
    }
    return NO;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.languages.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.languages[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:self.nativeLanguagePickerView]) {
        self.nativeLanguageField.text = self.languages[row];
        [self.nativeLanguagePickerView setHidden:YES];
    } else {
        self.targetLanguageField.text = self.languages[row];
        [self.targetLanguagePickerView setHidden:YES];
    }
}

- (IBAction)didTapSignup:(id)sender {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser[@"fullName"] = self.nameField.text;
    newUser.email = self.emailField.text;
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    newUser[@"nativeLanguage"] = self.nativeLanguageField.text;
    newUser[@"targetLanguage"] = self.targetLanguageField.text;
    newUser[@"profciencyLevel"] = self.proficiencyLevelField.text;
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            // manually segue to logged in view
            SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeFeed"];
        }
    }];
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
