//
//  PostProfileTableViewCell.h
//  Lingora
//
//  Created by Daphne Lopez on 7/13/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@end

NS_ASSUME_NONNULL_END
