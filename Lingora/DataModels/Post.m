//
//  Post.m
//  Lingora
//
//  Created by Daphne Lopez on 7/6/22.
//

#import "Post.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic postText;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserPost:(NSString *)postText withCompletion:(PFBooleanResultBlock)completion {
    
    Post *newPost = [Post new];
    newPost.author = [PFUser currentUser];
    newPost.postText = postText;
    
    [newPost saveInBackgroundWithBlock: completion];
}

@end
