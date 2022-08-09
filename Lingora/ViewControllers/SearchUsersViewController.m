//
//  SearchUsersViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 8/8/22.
//

#import "SearchUsersViewController.h"

@interface SearchUsersViewController () <FilterUserSearchDelegate>

@end

@implementation SearchUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)sendFiltersBack:(NSString *)language withRange:(NSString *)miles interests:(NSArray *)interests {
    self.interests = interests;
    self.targetLanguageField = language;
    self.locationField = miles;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    FilterUserSearchViewController *filterVC = [segue destinationViewController];
    // Pass the selected object to the new view controller.
    filterVC.delegate = self;
}

@end
