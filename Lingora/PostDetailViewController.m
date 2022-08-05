//
//  PostDetailViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/13/22.
//

#import "PostDetailViewController.h"
#import "Parse/PFImageView.h"
#import "DateTools/DateTools.h"
#import "ViewProfileViewController.h"
#import "SceneDelegate.h"
@import MLKit;

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
    [self createTapGestureRecognizer];
}

- (void)setPostProperties {
    PFUser *user = self.post.author;
    self.profilePicture.file = user[@"image"];
    [self.profilePicture loadInBackground];
    self.nameLabel.text = user[@"fullName"];
    self.usernameLabel.text = user.username;
    self.postTextLabel.text = self.post.postText;
    self.languageLabel.text = user[@"nativeLanguage"];
    self.timestampLabel.text = [self.post.createdAt shortTimeAgoSinceNow];
}


- (void)createTapGestureRecognizer {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"Double tap recognized");
        if (PFUser.currentUser[@"savedPosts"] != nil) {
            NSMutableArray *saved = [[NSMutableArray alloc] initWithArray:PFUser.currentUser[@"savedPosts"]];
            if (![saved containsObject:self.post]) {
                [saved addObject:self.post];
                PFUser.currentUser[@"savedPosts"] = [[NSArray alloc] initWithArray:saved];
            }
        } else {
            NSArray *saved = [[NSArray alloc] initWithObjects:self.post, nil];
            PFUser.currentUser[@"savedPosts"] = saved;
        }
        [PFUser.currentUser saveInBackground];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"PostProfile"]) {
        PFUser *dataToPass = self.post[@"author"];
        ViewProfileViewController *viewProfileVC = (ViewProfileViewController *) [segue destinationViewController];
        viewProfileVC.user = dataToPass;
    }
}

- (IBAction)didTapProfilePicture:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
}


- (MLKTranslateLanguage)identifyTextLanguage:(NSString *)text {
    MLKLanguageIdentification *languageId = [MLKLanguageIdentification languageIdentification];
    __block MLKTranslateLanguage language = nil;
    [languageId identifyLanguageForText:text completion:^(NSString * _Nullable languageCode, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Failed with error: %@", error.localizedDescription);
                return;
            }
            if (![languageCode isEqualToString:@"und"] ) {
                NSLog(@"Identified Language: %@", languageCode);
                language = (MLKTranslateLanguage) languageCode;
                MLKTranslateLanguage nativeLanguage = (MLKTranslateLanguage) PFUser.currentUser[@"nativeLanguageTag"];
                MLKTranslateLanguage targetLanguage = (MLKTranslateLanguage) PFUser.currentUser[@"targetLanguageTag"];
                if (nativeLanguage == language) {
                    [self translateText:language toLanguage:targetLanguage];
                    NSLog(@"Translate Language: %@", targetLanguage);
                } else {
                    [self translateText:language toLanguage:nativeLanguage];
                }
                
            } else {
                NSLog(@"No language was identified");
            }
    }];
    return language;
}


- (void)translateText:(MLKTranslateLanguage)sourceLanguage toLanguage:(MLKTranslateLanguage)translateLanguage {
    // Create an English-Spanish translator:
    MLKTranslatorOptions *options = [[MLKTranslatorOptions alloc] initWithSourceLanguage:sourceLanguage
                                    targetLanguage:translateLanguage];
    MLKTranslator *translator = [MLKTranslator translatorWithOptions:options];
    MLKModelDownloadConditions *conditions = [[MLKModelDownloadConditions alloc] initWithAllowsCellularAccess:NO
                                             allowsBackgroundDownloading:YES];
    [translator downloadModelIfNeededWithConditions:conditions completion:^(NSError *_Nullable error) {
        if (error != nil) {
            return;
        }
    // Model downloaded successfully. Okay to start translating.
    [translator translateText:self.postTextLabel.text completion:^(NSString *_Nullable translatedText, NSError *_Nullable error) {
        if (error != nil || translatedText == nil) {
            return;
        }

        // Translation succeeded.
        self.postTextLabel.text = translatedText;
        MLKTranslateRemoteModel *model = [MLKTranslateRemoteModel translateRemoteModelWithLanguage:translateLanguage];
        [[MLKModelManager modelManager] deleteDownloadedModel:model completion:^(NSError * _Nullable error) {
            if (error != nil) {
                return;
            }
            NSLog(@"DELETED MODEL"); }];
        }];
    }];
}

- (IBAction)translate:(id)sender {
    [self identifyTextLanguage:self.postTextLabel.text];
}

@end
