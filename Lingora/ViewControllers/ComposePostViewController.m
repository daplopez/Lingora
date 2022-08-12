//
//  ComposePostViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/8/22.
//

#import "ComposePostViewController.h"
#import "SceneDelegate.h"
#import "Post.h"
#import "Parse/PFImageView.h"

@interface ComposePostViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UITextView *postTextView;

@end

@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (PFUser.currentUser[@"image"] != nil) {
        self.profilePicture.file = PFUser.currentUser[@"image"];
        [self.profilePicture loadInBackground];
    }
}

- (IBAction)didTapCancel:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
}

- (IBAction)didTapShare:(id)sender {
    [Post postUserPost:self.postTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error sharing post");
        } else {
            NSLog(@"Successfully posted");
        }
    }];
    NSLog(@"%@", sender);
    NSLog(@"CHECK");
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
}

@end
