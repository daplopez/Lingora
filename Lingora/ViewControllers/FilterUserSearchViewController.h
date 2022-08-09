//
//  FilterUserSearchViewController.h
//  Lingora
//
//  Created by Daphne Lopez on 8/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FilterUserSearchDelegate <NSObject>

-(void)sendFiltersBack:(NSString *)language withRange:(NSString *)miles interests:(NSArray *)interests;

@end

@interface FilterUserSearchViewController : UIViewController

@property (nonatomic, weak) id<FilterUserSearchDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
