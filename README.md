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
[Add picture of your hand sketched wireframes in this section]
<img src="https://i.imgur.com/TuBLV3P.jpg" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
