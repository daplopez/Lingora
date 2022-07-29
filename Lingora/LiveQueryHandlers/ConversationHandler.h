//
//  ConversationHandler.h
//  Lingora
//
//  Created by Daphne Lopez on 7/28/22.
//

#import <Foundation/Foundation.h>
#import "Conversation.h"
#import "Parse/Parse.h"
#import "ConversationManager.h"

NS_ASSUME_NONNULL_BEGIN
@class ConversationHandler;

@interface ConversationHandler : NSObject

- (instancetype)init;

- (PFQuery *)queryForConversations:(ConversationManager *) manager;
- (PFQuery *)queryForConversationsThisUserCreated;
- (PFQuery *)queryForConversationsCreatedByOthers;
- (PFLiveQueryClient *)liveQueryClientForConversationManager:(ConversationManager *)manager;
- (NSArray *)conversationManager:(ConversationManager *)manager didCreateConversation:(NSArray *)conversations;

@end

NS_ASSUME_NONNULL_END
