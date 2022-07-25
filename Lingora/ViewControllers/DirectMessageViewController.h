//
//  DirectMessageViewController.h
//  Lingora
//
//  Created by Daphne Lopez on 7/25/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Conversation.h"

NS_ASSUME_NONNULL_BEGIN

@interface DirectMessageViewController : UIViewController
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) Conversation *conversation;
@end

NS_ASSUME_NONNULL_END
