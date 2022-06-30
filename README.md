Original App Design Project - README Template
===

# Lingora

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
This app will allow language-learners to match with each other based on what language they are learning. The goal is for each user to meet people that speak the langauge they are trying to learn and who is trying to learn the language that the user is learning. This would allow both users to speak to each other to communicate in their target lanaguage. The app would allow the user to select their desired language and then show suggestions based on those that speak that language and are nearby. Each user would have a profile where they can list their interests and make public posts. In addition, there woud be a feature to allow users to translate any text such as messages or posts.

### App Evaluation
- **Category:** Education / Social
- **Mobile:** Users would be able to look at a map to see which users are nearby, which would require access to location. The accessibility of a mobile app allowing you to send messages and view on-the-go also makes it more uniquely mobile. 
- **Story:** This app's value comes from being able to connect language-learners with each other. This would be a great platform to practice your skills and meet others. 
- **Market:** My audience is language-leaners who want to gain practice in using the language that they are learning. This would likely be a very niche group of people. While other language-learning apps have a large number of users, I feel like this app would not be the most beginner-friendly app since users would need to already have some knowledge of the language they are trying to learn in order to communicate with others, or otherwise they wouldn't be getting much benefit from the app. 
- **Habit:** Ideally, the user would use this app daily, for at least 30 minutes. There would be daily or weekly reminders set up by the user to remind them to open the app. In order for users to build connections with each other and to retain what they are learning, it'd be best for them to build a habit of practicing daily or weekly. 
- **Scope:** It will be challenging to implement some of the features sch as translation and sending voice memos but a very simple app that allows for matching, posting, and messaging is attainable in the given timeframe. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Users can create an account
* Users can login
* Users can sign out
* Users can message each other
* Users can view a map of those nearby
* Users have a profile and can update it
* Users can view each other's profiles
* Users can make posts that would be visible on their profile
* Users can click on posts to view them in detail
* Users can translate text
* Settings (Accesibility, General, etc.)

**Optional Nice-to-have Stories**

* Users can reply to posts on another user's profile
* Users can like/unlike posts
* Users can delete their posts
* Users can follow/unfollow other users
* Users can see a feed of popular posts/ friend's posts
* Users can hear the pronunciation of text
* Users can get notified when they receive a new message
* Users can get daily reminders
* Users can link other social media platforms to their profile
* Users can send voice memos
* Users can make video calls
* Users can expand their radius
* Users can choose to see others nearby in a list view instead of map
* Users can see a recommended list of other users based on similar interests
* Users can include people that are also learning the same language
* Users can filter results by preferences/times available
* Users can set proficiency
* Users can add multiple languages 
* User can change their language preferences
* Users can search for others
* Users can select from recommended prompts to start a conversation
* Users can change app settings
* Users can create group chats

### 2. Screen Archetypes

* Login screen
   * Users can login in order to get access to their account
   * Buttons to login or to sign up if they haven't already created an account
* Registration screen
   * Users can create a new account
   * Needs to fill in all fields, such as their native langauge and target language in addition to username and password
* Home Screen
    * Upon login, users are taken to a home screen where they can view a stream of their friends' posts and popular posts in their target language
* Detail Screen
    * Users can click on individual posts from the stream and view them in detail, which would include the post's author, their profile image, and timestamp
* Message Compose Screen
    * Users can compose a new message to another user 
* Post Compose Screen
    * Users can compose posts 
* Profile Screen 
    * Users can set a profile picture, add interests, and compose posts, which other users can view
* Map Screen
    * Users can see a map of nearby users based on the prefernces they selected and within a certain radius and can then choose to view their profile or message them
* Message screen
    * Users can send messages to other users 
* Search
    * Users can look up other users based on their name or username

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home: friends's posts / popular posts
* Messages: view direct messages
* Map: view a map of other users nearby
* Profile: user's profile

**Flow Navigation** (Screen to Screen)

* Login Screen
   * Home
   * Registration screen if new user
* Registration screen
   * Home once user has created an account
* Home screen
   * Message compose screen when you click message icon next to a profile
   * Also to user's profile if you click on their profile picture or username
   * Details view if you click on a post
* Message screen
    * Can take you to user's profile if you click on their profile picture or username
* Search screen
    * To profile/message if you click on a profile
* Map Screen
    * To profile if you click on user's profile image



## Wireframes
[sketched wireframe]
<img src="https://i.imgur.com/TuBLV3P.jpg" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
### Models
* Users 
    | Property      | Type     | Description |
    | ------------- | -------- | ------------|
    Required
    | name      | String   | a user's full name |
    | username      | String   | a user's screenname |
    | email        | String  | a user's email |
    | profile picture         | File     | image that the user can set on their profile |
    | native language | String | the language that the user is fluent in| 
    | target langauge  | String | the language that the user wants to learn|
    | interests | Array | array of user's different inetersts|
    | joined | Date | date when user joined the app | 
    Stretch
    | numFollowers       | Number   | number of users that are following them |
    | numFollowing | Number   | number of other users they are following |
    | followers | Array | array of all users that are followers|
    | following | Array | array of all users they are following |
    | lastActive | Date | time when a user was last atcive on the app| 

* Posts
    | Property      | Type     | Description |
    | ------------- | -------- | ------------|
    Required
    | author        | Pointer to a User| the post's author |
    | post message  | String   | the post's text |
    | image         | File     | image that user can post along with their message|
    Stretch
    | commentsCount | Number   | number of comments that has been posted to an image |
    | likesCount    | Number   | number of likes for the post |
    | createdAt     | Date | date when post is created (default field) |
    | updatedAt     | Date | date when post is last updated (default field) |
    
* Message
    | Property      | Type     | Description |
    | ------------- | -------- | ------------|
    Required
    | author        | Pointer to a User| the message's author |
    | text  | String   | the message's text |
    | image         | File     | image that user can send along with their message|
    Stretch
    | createdAt     | Date | date when message is created (default field) |
    | updatedAt     | Date | date when message is last updated (default field) |
    
* Location 
    | Property      | Type     | Description |
    | ------------- | -------- | ------------|
    Required
    | users        | Arrary | all the users within this location |

* Schedules 
    | Property      | Type     | Description |
    | ------------- | -------- | ------------|
    Required
    | time        | Arrary | users within same time blocks for studying |
    

### Networking
[network requests by screen ]
* Home Screen
    * (Read/GET) Query all posts frome users that the user is following
     ``` Objective-C
     NSArray *following = user.following;
     NSArray *posts = [[NSArray alloc] init]
     // for each follower
     PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:following.user.username];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSLog(@"Successfully got posts");
            self.userPosts add:posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    ```
    * (Read/GET) Query all posts where likes are > 100
* Compose Message screen
    * (Create/POST) Create a new message object
    ``` Objective C
    NSString *urlString = @"add-endpoint-here";
    NSDictionary *parameters = @{@"message": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable messageDictionary) {
        Message *newMessage = [[Post alloc]initWithDictionary:messageDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
    ```
* Compose Post screen
    * (Create/POST) Create a new post object
    ``` Objective C
    NSString *urlString = @"add-endpoint-here";
    NSDictionary *parameters = @{@"post": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable postDictionary) {
        Post *newPost = [[Post alloc]initWithDictionary:postDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
    ```
* Profile screen
    * (Read/GET) Query logged in user object
    * (Read/GET) Query all posts that the user is an author of
    * (Update/PUT) Update user profile image
    ``` Objective C
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:PFUser.currentUser.username];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSLog(@"Successfully got posts");
            self.userPosts = posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    ```
* Map Screen 
    * (Read/GET) Query users within a certain location

- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
