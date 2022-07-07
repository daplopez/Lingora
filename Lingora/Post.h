//
//  Post.h
//  Lingora
//
//  Created by Daphne Lopez on 7/6/22.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *postText;
@property (nonatomic, strong) PFUser *author;

+ (void) postUserPost: ( NSString * _Nullable )postText withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
