//
//  SearchUsersViewController.h
//  Lingora
//
//  Created by Daphne Lopez on 8/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchUsersViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *targetLanguageField;
@property (strong, nonatomic) NSArray *interests;

@end

NS_ASSUME_NONNULL_END
