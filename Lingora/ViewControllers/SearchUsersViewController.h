//
//  SearchUsersViewController.h
//  Lingora
//
//  Created by Daphne Lopez on 8/8/22.
//

#import <UIKit/UIKit.h>
#import "FilterUserSearchViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchUsersViewController : UIViewController

@property (weak, nonatomic) NSString *locationField;
@property (weak, nonatomic) NSString *targetLanguageField;
@property (strong, nonatomic) NSArray *interests;

@end

NS_ASSUME_NONNULL_END
