//
//  UserSearchTableViewCell.h
//  Lingora
//
//  Created by Daphne Lopez on 8/8/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserSearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLanguageLabel;

@end

NS_ASSUME_NONNULL_END
