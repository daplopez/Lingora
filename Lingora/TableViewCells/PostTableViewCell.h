//
//  PostTableViewCell.h
//  Lingora
//
//  Created by Daphne Lopez on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@class PostTableViewCell;

@protocol PostTableViewCellProfileDelegate <NSObject>

- (void)didTapProfileButton:(PostTableViewCell *)cell;

@end

@interface PostTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *postProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *postNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;
@property (weak, nonatomic) id <PostTableViewCellProfileDelegate> buttonDelegate;
@end

NS_ASSUME_NONNULL_END
