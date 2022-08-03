//
//  Message.m
//  Lingora
//
//  Created by Daphne Lopez on 7/22/22.
//

#import "Message.h"
#import "Conversation.h"

@implementation Message

@dynamic author;
@dynamic messageText;
@dynamic username;
@dynamic convoID;

+ (nonnull NSString *)parseClassName {
    return @"Message";
}

+ (void) sendMessage:(NSString *)messageText conversation:(Conversation *)conversation withCompletion:(PFBooleanResultBlock)completion {
    
    Message *newMessage = [Message new];
    newMessage.author = [PFUser currentUser];
    newMessage.username = PFUser.currentUser.username;
    newMessage.messageText = messageText;
    newMessage.convoID = conversation.objectId;
    
    [newMessage saveInBackgroundWithBlock: completion];
}


@end
