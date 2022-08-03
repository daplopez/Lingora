//
//  Message.h
//  Lingora
//
//  Created by Daphne Lopez on 7/22/22.
//

#import <Parse/Parse.h>
#import "Conversation.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *messageText;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *convoID;

+ (void) sendMessage: ( NSString * _Nullable )messageText conversation:(Conversation *)conversation withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
