//
//  ProfileTableViewCell.h
//  Lingora
//
//  Created by Daphne Lopez on 7/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;

@end

NS_ASSUME_NONNULL_END
