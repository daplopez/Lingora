//
//  ConversationHandler.m
//  Lingora
//
//  Created by Daphne Lopez on 7/28/22.
//

#import "ConversationHandler.h"
#import "Conversation.h"
#import "ConversationManager.h"
@import ParseLiveQuery;

@interface ConversationHandler ()

@property (nonatomic, strong, readonly) Conversation *convo;
@property (nonatomic, strong, readonly) PFLiveQueryClient *client;

@end

@implementation ConversationHandler

// Query for conversations in create handler in manager
- (PFQuery *)queryForConversations {
    PFQuery *conversationsInitiatedByCurrentUser = [self queryForConversationsThisUserCreated];
    PFQuery *conversationsInitiatedByOthers = [self queryForConversationsCreatedByOthers];
    NSArray *conversationQueries = [[NSArray alloc] initWithObjects:conversationsInitiatedByCurrentUser, conversationsInitiatedByOthers, nil];
    PFQuery *queryAllConversations = [PFQuery orQueryWithSubqueries:conversationQueries];
    NSArray *includeUsers = [[NSArray alloc] initWithObjects:@"user1", @"user2", @"messages", nil];
    [queryAllConversations includeKeys:includeUsers];
    [queryAllConversations orderByDescending:@"createdAt"];
    
    return queryAllConversations;
}

- (PFQuery *)queryForConversationsThisUserCreated {
    PFQuery *query = [PFQuery queryWithClassName:@"Conversation"];
    [query whereKey:@"username1" equalTo:PFUser.currentUser.username];
    
    return query;
}

- (PFQuery *)queryForConversationsCreatedByOthers {
    PFQuery *query = [PFQuery queryWithClassName:@"Conversation"];
    [query whereKey:@"username2" equalTo:PFUser.currentUser.username];

    return query;
}


// Return current client
- (PFLiveQueryClient *)liveQueryClientForChatRoomManager:(ConversationManager *)manager {
  return _client;
}

@end
