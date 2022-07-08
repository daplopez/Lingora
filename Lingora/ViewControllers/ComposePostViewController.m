//
//  ComposePostViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/8/22.
//

#import "ComposePostViewController.h"
#import "SceneDelegate.h"
#import "Post.h"

@interface ComposePostViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UITextView *postTextView;

@end

@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapCancel:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeFeed"];
}

- (IBAction)didTapShare:(id)sender {
    [Post postUserPost:self.postTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error sharing post");
            } else {
                NSLog(@"Successfully posted");
                
            }
    }];
    
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeFeed"];
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
