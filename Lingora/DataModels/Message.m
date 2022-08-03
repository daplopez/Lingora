//
//  Message.m
//  Lingora
//
//  Created by Daphne Lopez on 7/22/22.
//

#import "Message.h"

@implementation Message

@dynamic author;
@dynamic messageText;
@dynamic username;

+ (nonnull NSString *)parseClassName {
    return @"Message";
}

+ (void) sendMessage:(NSString *)messageText withCompletion:(PFBooleanResultBlock)completion {
    
    Message *newMessage = [Message new];
    newMessage.author = [PFUser currentUser];
    newMessage.username = PFUser.currentUser.username;
    newMessage.messageText = messageText;
    
    [newMessage saveInBackgroundWithBlock: completion];
}


@end
