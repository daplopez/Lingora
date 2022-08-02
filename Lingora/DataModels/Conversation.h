//
//  Conversation.h
//  Lingora
//
//  Created by Daphne Lopez on 7/22/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Conversation : PFObject <PFSubclassing>

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) NSArray *usersInConversation;
@property (nonatomic, strong) NSString *username1;
@property (nonatomic, strong) NSString *username2;

+ (void) createConversation: (NSArray * _Nullable )messages withUser:(PFUser *)user2 withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
