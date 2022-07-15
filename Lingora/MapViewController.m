//
//  MapViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/14/22.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>

@interface MapViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation * _Nullable currentLocation;
@property (strong, nonatomic) GMSMapView *mapView;
@property float preciseLocationZoomLevel;
@property float approximateLocationZoomLevel;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLocationManager];
    
    [self defaultCoordinates];
}


- (void)initLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.distanceFilter = 50;
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
}


- (void)defaultCoordinates {
    // Create a default GMSCameraPosition that tells the map to display the
    // coordinate 37.4530,-122.1817 at zoom level 15.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.4530 longitude:-122.1817 zoom:15];
    self.mapView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    self.mapView.myLocationEnabled = YES;
    [self.view addSubview:self.mapView];
}

// Delegates to handle events for the location manager.
#pragma mark - CLLocationManagerDelegate

// Handle incoming location events.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = locations.lastObject;
    NSLog(@"Location: %@", location);
  
//    float zoomLevel = self.locationManager.accuracyAuthorization == CLAccuracyAuthorizationFullAccuracy ? self.preciseLocationZoomLevel:self.approximateLocationZoomLevel;
    GMSCameraPosition * camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                           longitude:location.coordinate.longitude zoom:10];
  
    self.mapView.camera = camera;
    [self.mapView animateToCameraPosition:camera];
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
      // Display the map using the default location.
      self.mapView.hidden = NO;
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
