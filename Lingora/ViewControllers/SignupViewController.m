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
@property (weak, nonatomic) IBOutlet UIPickerView *nativeLanguagePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *targetLanguagePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *proficiencyPickerView;
@property (strong, nonatomic) NSArray *languages;
@property (strong, nonatomic) NSArray *proficiency;
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpPickerViews];
    
}

- (void)setUpPickerViews {
    self.nativeLanguagePickerView.delegate = self;
    self.nativeLanguagePickerView.dataSource = self;
    self.targetLanguagePickerView.delegate = self;
    self.targetLanguagePickerView.dataSource = self;
    self.proficiencyPickerView.delegate = self;
    self.proficiencyPickerView.dataSource = self;
    
    self.nativeLanguageField.delegate = self;
    self.nativeLanguageField.inputView = self.nativeLanguagePickerView;
    self.targetLanguageField.delegate = self;
    self.targetLanguageField.inputView = self.targetLanguagePickerView;
    self.proficiencyLevelField.delegate = self;
    self.proficiencyLevelField.inputView = self.proficiencyPickerView;
    
    [self.nativeLanguagePickerView setHidden:YES];
    [self.targetLanguagePickerView setHidden:YES];
    [self.proficiencyPickerView setHidden:YES];
    
    self.languages = [[NSArray alloc] initWithObjects:@"English", @"Spanish", nil];
    
    self.proficiency = [[NSArray alloc] initWithObjects:@"Beginner", @"Intermediate", @"Advanced", nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.nativeLanguageField]) {
        [self.nativeLanguagePickerView setHidden:NO];
    } else if ([textField isEqual:self.targetLanguageField]) {
        [self.targetLanguagePickerView setHidden:NO];
    } else {
        [self.proficiencyPickerView setHidden:NO];
    }
    return NO;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:self.proficiencyPickerView]) {
        return self.proficiency.count;
    } else {
        return self.languages.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView isEqual:self.proficiencyPickerView]) {
        return self.proficiency[row];
    } else {
        return self.languages[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:self.nativeLanguagePickerView]) {
        self.nativeLanguageField.text = self.languages[row];
        [self.nativeLanguagePickerView setHidden:YES];
    } else if ([pickerView isEqual:self.targetLanguagePickerView]) {
        self.targetLanguageField.text = self.languages[row];
        [self.targetLanguagePickerView setHidden:YES];
    } else {
        self.proficiencyLevelField.text = self.proficiency[row];
        [self.proficiencyPickerView setHidden:YES];
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
