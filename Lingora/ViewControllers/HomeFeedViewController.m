//
//  HomeFeedViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/6/22.
//

#import "HomeFeedViewController.h"
#import "SceneDelegate.h"
#import "Parse/Parse.h"
#import "PostTableViewCell.h"
#import "Post.h"
#import "Parse/PFImageView.h"
#import "ViewProfileViewController.h"
#import "PostDetailViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Parse/PFGeoPoint.h"

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate>
// current user info
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nativeLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLanguageLabel;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) NSArray *filteredPosts;
// location
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation * _Nullable currentLocation;
@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    [self initLocationManager];
    
    [self createRefreshControl];
    [self setUserProperties];
    [self queryForUserPosts];
    [self.tableView reloadData];
    //TODO: change secs to 1 later but making too many requests rn
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
}


- (void)initLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.distanceFilter = 50;
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
}

 

- (void)onTimer {
    [self setUserProperties];
    [self queryForUserPosts];
    [self.tableView reloadData];
}


// Retrieve the current user's properties
- (void)setUserProperties {
    PFUser *curUser = [PFUser currentUser];
    
    self.nameLabel.text = curUser[@"fullName"];
    self.nativeLanguageLabel.text = curUser[@"nativeLanguage"];
    self.targetLanguageLabel.text = curUser[@"targetLanguage"];
    if (curUser[@"image"]) {
        self.profilePicture.file = curUser[@"image"];
        [self.profilePicture loadInBackground];
    }
    
}


- (void)createRefreshControl {
    // refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(queryForUserPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}


- (void)queryForUserPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSLog(@"Successfully got posts");
            self.posts = posts;
            self.filteredPosts = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
}

- (IBAction)didTapLogout:(id)sender {
    // Logout current user
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {}];
    // Return to Login screen
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeVC"];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.filteredPosts[indexPath.row];
    cell.postTextLabel.text = post[@"postText"];
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredPosts.count;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = 0;
    [UIView animateWithDuration:0.5 animations: ^{
        cell.alpha = 1;
    }];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postText CONTAINS[cd] %@", searchText];
        self.filteredPosts = [self.posts filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredPosts = self.posts;
    }
    [self.tableView reloadData];
 
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"PostDetail"]) {
        NSIndexPath *indexPath =[self.tableView indexPathForCell:sender];
        Post *dataToPass = self.posts[indexPath.row];
        dataToPass.author = [dataToPass.author fetchIfNeeded];
        PostDetailViewController *detailsVC = (PostDetailViewController *) [segue destinationViewController];
        detailsVC.post = dataToPass;
    }
}


// Delegates to handle events for the location manager.
#pragma mark - CLLocationManagerDelegate

// Handle incoming location events.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    self.currentLocation = locations.lastObject;
    
    double curLat = self.currentLocation.coordinate.latitude;
    double curLong = self.currentLocation.coordinate.longitude;
    PFUser *curUser = PFUser.currentUser;
    PFGeoPoint *pastLocation = curUser[@"location"];
    if (pastLocation == nil) {
        curUser[@"location"] = [PFGeoPoint geoPointWithLatitude:curLat longitude:curLong];
        [PFUser.currentUser saveInBackground];
    } else {
        double pastLat = pastLocation.latitude;
        double pastLong = pastLocation.longitude;
        if (curLat != pastLat || curLong != pastLong) {
            curUser[@"location"] = [PFGeoPoint geoPointWithLatitude:curLat longitude:curLong];
            [PFUser.currentUser saveInBackground];
        }
    }
}

// Handle authorization for the location manager.
- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager
{
  // Check accuracy authorization
  CLAccuracyAuthorization accuracy = manager.accuracyAuthorization;
  switch (accuracy) {
    case CLAccuracyAuthorizationFullAccuracy:
      NSLog(@"Location accuracy is precise.");
      break;
    case CLAccuracyAuthorizationReducedAccuracy:
      NSLog(@"Location accuracy is not precise.");
      break;
  }
  
  // Handle authorization status
  switch (manager.authorizationStatus) {
    case kCLAuthorizationStatusRestricted:
      NSLog(@"Location access was restricted.");
      break;
    case kCLAuthorizationStatusDenied:
      NSLog(@"User denied access to location.");
    case kCLAuthorizationStatusNotDetermined:
      NSLog(@"Location status not determined.");
    case kCLAuthorizationStatusAuthorizedAlways:
    case kCLAuthorizationStatusAuthorizedWhenInUse:
      NSLog(@"Location status is OK.");
  }
}

// Handle location manager errors.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
  [manager stopUpdatingLocation];
  NSLog(@"Error: %@", error.localizedDescription);
}


@end
