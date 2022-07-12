//
//  ProfileViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/8/22.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "Post.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "ProfileInterestsCollectionViewCell.h"
#import "ProfileImageCollectionViewCell.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nativeLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLanguageLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSArray *posts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *userInterests;
@property (strong, nonatomic) NSMutableArray *myImages;
@property (weak, nonatomic) IBOutlet UICollectionView *interestsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.interestsCollectionView.delegate = self;
    self.interestsCollectionView.dataSource = self;
    self.imagesCollectionView.delegate = self;
    self.imagesCollectionView.dataSource = self;
    
    [self createRefreshControl];
    [self getUserData];
    [self queryForPosts];
    [self.tableView reloadData];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:true];

}


- (void)onTimer {
    [self getUserData];
    [self queryForPosts];
    [self.tableView reloadData];
}

- (void)getUserData {
    PFUser *user = [PFUser currentUser];
    
    self.nameLabel.text = user[@"fullName"];
    self.nativeLanguageLabel.text = user[@"nativeLanguage"];
    self.targetLanguageLabel.text = user[@"targetLanguage"];
    if (user[@"image"] != nil) {
        self.profilePicture.file = user[@"image"];
        [self.profilePicture loadInBackground];
    }
    
    if (user[@"interests"] != nil) {
        self.userInterests = [NSMutableArray arrayWithArray:user[@"interests"]];
    }
    
}


- (void)createRefreshControl {
    // refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(queryForPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)queryForPosts {
    
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSLog(@"Successfully got posts");
            self.posts = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    [self.refreshControl endRefreshing];
    
}

// For table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    Post *post = self.posts[indexPath.row];
    cell.postTextLabel.text = post[@"postText"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}


// For setting/changing profile picture

- (IBAction)didTapChangeProfilePic:(id)sender {
    [self useCamera];
}

- (void)useCamera {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so check that the camera is supported on device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        [self cameraUnavailableAlert:imagePickerVC];
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}


- (void)cameraUnavailableAlert: (UIImagePickerController *) imagePickerVC {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Camera not available" message:@"Defaulting to photo library" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // present the photo library instead
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    CGRect bounds = UIScreen.mainScreen.bounds;
    CGFloat width = bounds.size.width;
    if(editedImage) {
        editedImage = [self resizeImage:editedImage withSize:CGSizeMake(width, width)];
        self.profilePicture.file = [self getPFFileFromImage:editedImage];
        [self.profilePicture loadInBackground];
    } else {
        originalImage = [self resizeImage:originalImage withSize:CGSizeMake(width, width)];
        self.profilePicture.file = [self getPFFileFromImage:originalImage];
        [self.profilePicture loadInBackground];
    }
    
    [self.profilePicture loadInBackground];
    PFUser *curUser = [PFUser currentUser];
    curUser[@"image"] = self.profilePicture.file;
    [curUser saveInBackground];
        
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}


- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


// For interests collection group

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if ([collectionView isEqual:self.interestsCollectionView]) {
        ProfileInterestsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"profileInterestsCell" forIndexPath:indexPath];
        
        NSString *interest = self.userInterests[indexPath.row];
        cell.interestLabel.text = interest;
        return cell;
    } else {
        ProfileImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
        cell.profileImages.file = self.myImages[indexPath.row];
        [cell.profileImages loadInBackground];
        return cell;
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.interestsCollectionView]) {
        return self.userInterests.count;
    } else {
        return self.myImages.count;
    }
}


- (IBAction)didTapAddInterest:(id)sender {
    
    // create the actual alert controller view that will be the pop-up
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Interests" message:@"Add an interest below:" preferredStyle:(UIAlertControllerStyleAlert)];

    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Interest";
    }];


    // add the buttons/actions to the view controller
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];

    // add the cancel action to the alertController
    [alert addAction:cancelAction];

    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (self.userInterests != nil) {
            [self.userInterests addObject:alert.textFields[0].text];
        } else {
            self.userInterests = [[NSMutableArray alloc] initWithObjects:alert.textFields[0].text, nil];
        }
        [self.interestsCollectionView reloadData];
        
        PFUser.currentUser[@"interests"] = [NSArray arrayWithArray:self.userInterests];
        [PFUser.currentUser saveInBackground];
        
        
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)didTapRemoveInterest:(id)sender {
    // create the actual alert controller view that will be the pop-up
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Interests" message:@"Remove an by entering it below:" preferredStyle:(UIAlertControllerStyleAlert)];

    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Interest";
    }];


    // add the buttons/actions to the view controller
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];

    // add the cancel action to the alertController
    [alert addAction:cancelAction];

    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *newInterest = alert.textFields[0].text;
        if (self.userInterests != nil && [self.userInterests containsObject:newInterest]) {
            [self.userInterests removeObject:newInterest];
        } else {
            NSLog(@"Error, either array is null or does not contain that object");
            [self interestErrorAlert:sender];
        }
        [self.interestsCollectionView reloadData];
        
        PFUser.currentUser[@"interests"] = [NSArray arrayWithArray:self.userInterests];
        [PFUser.currentUser saveInBackground];
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)interestErrorAlert:(id)sender {
    // create the actual alert controller view that will be the pop-up
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"The value you entered does not exist" preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];

    // add the cancel action to the alertController
    [alert addAction:cancelAction];
    
    // add the buttons/actions to the view controller
    // create a cancel action
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self didTapRemoveInterest:sender];
    }];

    // add the try again action to the alertController
    [alert addAction:tryAgainAction];

    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)didTapAddImage:(id)sender {
    
}


@end
