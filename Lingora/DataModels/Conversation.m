//
//  Conversation.m
//  Lingora
//
//  Created by Daphne Lopez on 7/22/22.
//

#import "Conversation.h"

@implementation Conversation


@dynamic messages;
@dynamic user1;
@dynamic username1;
@dynamic user2;
@dynamic username2;

+ (nonnull NSString *)parseClassName {
    return @"Conversation";
}

+ (void) createConversation:(NSArray *)messages withUser:(PFUser *)user2 withCompletion:(PFBooleanResultBlock)completion {
    Conversation *newConversation = [Conversation new];
    newConversation.user1 = [PFUser currentUser];
    newConversation.username1 = newConversation.user1.username;
    newConversation.user2 = user2;
    newConversation.username2 = newConversation.user2.username;
    newConversation.messages = messages;
    
    [newConversation saveInBackgroundWithBlock: completion];
}


@end
