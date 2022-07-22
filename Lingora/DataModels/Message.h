//
//  Message.h
//  Lingora
//
//  Created by Daphne Lopez on 7/22/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *messageText;
@property (nonatomic, strong) PFUser *author;

+ (void) sendMessage: ( NSString * _Nullable )messageText withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
