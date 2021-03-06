//
//  ChatTableViewCell.h
//  Lingora
//
//  Created by Daphne Lopez on 7/19/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

NS_ASSUME_NONNULL_END
