//
//  AppDelegate.m
//  Lingora
//
//  Created by Daphne Lopez on 7/5/22.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
@import GoogleMaps;
@import ParseLiveQuery;
#import "ParseLiveQuery/ParseLiveQuery-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = [dict objectForKey: @"ParseAppID"];;
        configuration.clientKey = [dict objectForKey: @"ParseClientKey"];;
        configuration.server = [dict objectForKey: @"ParseServer"];;
    }];
    [Parse initializeWithConfiguration:config];
    
    [GMSServices provideAPIKey:[dict objectForKey: @"GMSAPI"]];
    
    return YES;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
