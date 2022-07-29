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

@interface ConversationHandler () <ConversationManagerDelegate, ConversationManagerDataSource>

//@property (nonatomic, strong) Conversation *convo;
@property (nonatomic, strong) PFLiveQueryClient *client;

@end

@implementation ConversationHandler

- (instancetype)init {
    self = [super init];
    if (!self) return self;

    //self.convo = conversation;
    NSString *server = @"wss://lingora.back4app.io";
    NSString *appID = @"br3tfJvr91ICV46owI5EuDK19G2dHpDsdIkNpur5";
    NSString *clientKey = @"MtocH1ODD1D95uh2FufxYdmivI9gIZtMpx2ynK4v";
    PFLiveQueryClient *queryClient = [[PFLiveQueryClient alloc] initWithServer:server applicationId:appID clientKey:clientKey];
    self.client = queryClient;
  return self;
}


// Query for conversations in create handler in manager
- (PFQuery *)queryForConversations:(ConversationManager *) manager {
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
- (PFLiveQueryClient *)liveQueryClientForConversationManager:(ConversationManager *)manager {
    return self.client;
}

// What to do when conversation is created
- (NSArray *)conversationManager:(ConversationManager *)manager didCreateConversation:(Conversation *)conversations forTableView:(UITableView *)tableView newConvos:(NSArray *)newConvos {
    
    NSLog(@"\nStart of creating a new conversation\n");
    NSMutableArray *newConvo = [[NSMutableArray alloc] initWithArray:newConvos];
    [newConvo addObject:conversations];
    newConvos = [NSArray arrayWithArray:newConvo];
    [tableView reloadData];
    NSLog(@"reload table View");
    NSLog(@"Table Vew should be reloaded");
    NSLog(@"\nEnd\n");
    return newConvos;
}

@end

