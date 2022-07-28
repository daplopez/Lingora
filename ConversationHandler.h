//
//  ConversationHandler.h
//  Lingora
//
//  Created by Daphne Lopez on 7/27/22.
//

#import <Foundation/Foundation.h>
#import "Conversation.h"
@import ParseLiveQuery;

NS_ASSUME_NONNULL_BEGIN

@interface ConversationHandler : NSObject

@property (nonatomic, strong, readonly) Conversation *convo;
@property (nonatomic, strong, readonly) PFLiveQueryClient *client;

@end

NS_ASSUME_NONNULL_END
