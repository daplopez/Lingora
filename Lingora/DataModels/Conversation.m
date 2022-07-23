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
@dynamic user2;

+ (nonnull NSString *)parseClassName {
    return @"Conversation";
}

+ (void) createConversation:(NSArray *)messages withUser:(PFUser *)user2 withCompletion:(PFBooleanResultBlock)completion {
    Conversation *newConversation = [Conversation new];
    newConversation.user1 = [PFUser currentUser];
    newConversation.user2 = user2;
    newConversation.messages = messages;
    
    [newConversation saveInBackgroundWithBlock: completion];
}


@end
