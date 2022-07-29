//
//  ConversationManager.m
//  Lingora
//
//  Created by Daphne Lopez on 7/28/22.
//

#import "ConversationManager.h"
#import "Parse/Parse.h"
@import ParseLiveQuery;

@interface ConversationManager()

@property (nonatomic, strong) PFLiveQueryClient *client;
@property (nonatomic, strong) PFQuery *query;
@property (nonatomic, strong) PFLiveQuerySubscription *subscription;

@end

@implementation ConversationManager

- (instancetype)initWithDataSource:(id<ConversationManagerDataSource>)dataSource delegate:(id<ConversationManagerDelegate>)delegate{
    self = [super init];
    if (!self) return self;

    self.dataSource = dataSource;
    self.delegate = delegate;

    return self;
}

- (void)connect:(UITableView *)tableView newConvos:(NSArray *)newConvos {
    self.client = [self.dataSource liveQueryClientForConversationManager:self];
    self.query = [self.dataSource queryForConversations:self];
    
    
    
    __weak typeof(self) weakSelf = self;

    self.subscription = [self.client subscribeToQuery:self.query];
    
    self.subscription = [self.subscription addCreateHandler:^(PFQuery<Conversation *> *query, PFObject *conversation) {
        [weakSelf.delegate conversationManager:weakSelf didCreateConversation:(Conversation *)conversation forTableView:tableView newConvos:newConvos];
    }];
}


- (BOOL)isConnected {
  return self.subscription != nil;
}

@end
