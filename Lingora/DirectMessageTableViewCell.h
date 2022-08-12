//
//  DirectMessageTableViewCell.h
//  Lingora
//
//  Created by Daphne Lopez on 7/25/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DirectMessageTableViewCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *messageTextLabel;
//@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;

@end

NS_ASSUME_NONNULL_END
