//
//  PostDetailViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/13/22.
//

#import "PostDetailViewController.h"
#import "Parse/PFImageView.h"

@interface PostDetailViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@end

@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPostProperties];
}

- (void)setPostProperties {
    PFUser *user = self.post.author;
    self.profilePicture.file = user[@"image"];
    [self.profilePicture loadInBackground];
    self.nameLabel.text = user[@"fullName"];
    self.usernameLabel.text = user.username;
    self.postTextLabel.text = self.post.postText;
    self.languageLabel.text = user[@"nativeLanguage"];
    
}

@end
