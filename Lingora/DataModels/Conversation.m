//
//  Conversation.m
//  Lingora
//
//  Created by Daphne Lopez on 7/22/22.
//

#import "Conversation.h"

@implementation Conversation


@dynamic messages;
@dynamic usersInConversation;
@dynamic username1;
@dynamic username2;

+ (nonnull NSString *)parseClassName {
    return @"Conversation";
}

+ (Conversation *) createConversation:(NSArray *)messages withUser:(PFUser *)user2 withCompletion:(PFBooleanResultBlock)completion {
    Conversation *newConversation = [Conversation new];
    newConversation.usersInConversation = [NSArray arrayWithObjects:[PFUser currentUser], user2, nil];
    newConversation.username1 = newConversation.usersInConversation[0][@"username"];
    newConversation.username2 = newConversation.usersInConversation[1][@"username"];
    newConversation.messages = messages;
    
    [newConversation saveInBackgroundWithBlock: completion];
    
    return newConversation;
}


@end
