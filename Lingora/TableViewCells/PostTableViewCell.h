//
//  PostTableViewCell.h
//  Lingora
//
//  Created by Daphne Lopez on 7/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *postNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;
@end

NS_ASSUME_NONNULL_END