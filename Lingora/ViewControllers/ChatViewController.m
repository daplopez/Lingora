//
//  ChatViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/19/22.
//

#import "ChatViewController.h"
#import "DirectMessageViewController.h"
#import "Conversation.h"
#import "Parse/Parse.h"
#import "ChatTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ConversationHandler.h"
#import "ConversationManager.h"
@import ParseLiveQuery;

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *conversations;
@property (strong, nonatomic) PFLiveQueryClient *client;
@property (strong, nonatomic) PFQuery *query;
@property (strong, nonatomic) PFLiveQuerySubscription *subscription;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self runQueryForConversations];
    [self.tableView reloadData];
}

- (void)runQueryForConversations {
    self.query = [self queryForAllConversations];

    // fetch data asynchronously
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *conversations, NSError *error) {
        if (conversations != nil) {
            NSLog(@"Successfully got users");
            [self liveQuerySetup];

            if (conversations.count != 0) {
                self.conversations = [NSMutableArray arrayWithArray:conversations];
                [self.tableView reloadData];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (PFQuery *)queryForAllConversations {
    PFQuery *conversationsInitiatedByCurrentUser = [self queryForConversationsThisUserCreated];
    PFQuery *conversationsInitiatedByOthers = [self queryForConversationsCreatedByOthers];
    NSArray *conversationQueries = [[NSArray alloc] initWithObjects:conversationsInitiatedByCurrentUser, conversationsInitiatedByOthers, nil];
    PFQuery *queryAllConversations = [PFQuery orQueryWithSubqueries:conversationQueries];
    //NSArray *includeUsers = [[NSArray alloc] initWithObjects:@"usersInConversation", nil];
    [queryAllConversations includeKey:@"usersInConversation"];
    [queryAllConversations orderByDescending:@"createdAt"];
    
    return queryAllConversations;
}

- (void)liveQuerySetup {
    self.client = [[PFLiveQueryClient alloc] init];
    self.query = [self queryForAllConversations];
    [self.query includeKey:@"usersInConversation"];
    self.subscription = [[self.client subscribeToQuery:self.query] addCreateHandler:^(PFQuery *query, PFObject *object) {
        Conversation *convo = (Conversation *)object;
        PFUser *user1 = [convo.usersInConversation[0] fetchIfNeeded];
        PFUser *user2 = [convo.usersInConversation[1] fetchIfNeeded];
        NSArray *convoUsers = [[NSArray alloc] initWithObjects:user1, user2, nil];
        convo.usersInConversation = [NSArray arrayWithArray:convoUsers];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.conversations insertObject:convo atIndex:0];
            [self.tableView reloadData];
        });
    }];
}


- (PFQuery *)queryForConversationsThisUserCreated {
    PFQuery *query = [PFQuery queryWithClassName:@"Conversation"];
    [query whereKey:@"username1" equalTo:PFUser.currentUser.username];
    
    return query;
}

- (PFQuery *)queryForConversationsCreatedByOthers {
    PFQuery *query = [PFQuery queryWithClassName:@"Conversation"];
    [query whereKey:@"username2" equalTo:PFUser.currentUser.username];

    return query;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    Conversation *curConvo = self.conversations[indexPath.row];
    PFUser *user1 = curConvo.usersInConversation[0];
    PFUser *user2 = curConvo.usersInConversation[1];
    PFUser *user = [user1.username isEqualToString:PFUser.currentUser.username] ? user2 : user1;
    cell.profilePicture.file = user[@"image"];
    [cell.profilePicture loadInBackground];
    cell.nameLabel.text = user[@"fullName"];
    
    if (curConvo.messages.count != 0) {
        cell.messageLabel.text = curConvo.messages[curConvo.messages.count - 1][@"messageText"];
    }
    return cell;
}

 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"ChatsToDM"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
         Conversation *convoToPass = self.conversations[indexPath.row];
         PFUser *userToPass = [convoToPass.usersInConversation[0][@"username"] isEqualToString:PFUser.currentUser.username] ? convoToPass.usersInConversation[1] : convoToPass.usersInConversation[0];
         DirectMessageViewController *messageVC = (DirectMessageViewController *) [segue destinationViewController];
         messageVC.conversation = convoToPass;
         messageVC.user = userToPass;
     }
 }

#pragma mark - DZNEmptyDataSet Delegate Methods

//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return [UIImage imageNamed:@"empty_placeholder"];
//}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No chats to display";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Start a new conversation by pressing message button above";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
