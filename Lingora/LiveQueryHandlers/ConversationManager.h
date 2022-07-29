//
//  ConversationManager.h
//  Lingora
//
//  Created by Daphne Lopez on 7/28/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Conversation.h"
@import ParseLiveQuery;

NS_ASSUME_NONNULL_BEGIN

@class ConversationManager;

@protocol ConversationManagerDataSource <NSObject>

- (PFQuery *)queryForConversations:(ConversationManager *)manager;
- (PFLiveQueryClient *)liveQueryClientForConversationManager:(ConversationManager *)manager;

@end

@protocol ConversationManagerDelegate <NSObject>

- (void)conversationManager:(ConversationManager *)manager didCreateConversation:(NSArray *)conversations;

@end

@interface ConversationManager : NSObject

@property (nonatomic, weak) id<ConversationManagerDataSource> dataSource;
@property (nonatomic, weak) id<ConversationManagerDelegate> delegate;

- (instancetype)initWithDataSource:(id<ConversationManagerDataSource>)dataSource delegate:(id<ConversationManagerDelegate>)delegate;

- (void)connect;


@end

NS_ASSUME_NONNULL_END
