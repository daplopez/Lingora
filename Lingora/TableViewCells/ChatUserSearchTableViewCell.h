//
//  ChatUserSearchTableViewCell.h
//  Lingora
//
//  Created by Daphne Lopez on 7/25/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatUserSearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@end

NS_ASSUME_NONNULL_END
