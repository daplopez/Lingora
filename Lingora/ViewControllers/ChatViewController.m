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
@import ParseLiveQuery;

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *conversations;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self queryForConversations];
    [self.tableView reloadData];
}

- (void)queryForConversations {
    PFQuery *conversationsInitiatedByCurrentUser = [self queryForConversationsThisUserCreated];
    PFQuery *conversationsInitiatedByOthers = [self queryForConversationsCreatedByOthers];
    NSArray *conversationQueries = [[NSArray alloc] initWithObjects:conversationsInitiatedByCurrentUser, conversationsInitiatedByOthers, nil];
    PFQuery *queryAllConversations = [PFQuery orQueryWithSubqueries:conversationQueries];
    NSArray *includeUsers = [[NSArray alloc] initWithObjects:@"user1", @"user2", @"messages", nil];
    [queryAllConversations includeKeys:includeUsers];
    [queryAllConversations orderByDescending:@"createdAt"];
    
    // fetch data asynchronously
    [queryAllConversations findObjectsInBackgroundWithBlock:^(NSArray *conversations, NSError *error) {
        if (conversations != nil) {
            NSLog(@"Successfully got users");
            if (conversations.count != 0) {
                self.conversations = [NSArray arrayWithArray:conversations];
                NSLog(@"%@", self.conversations[0][@"user2"]);
                [self.tableView reloadData];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
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
    PFUser *user = [curConvo.user1.username isEqualToString:PFUser.currentUser.username] ? curConvo.user2 : curConvo.user1;
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
         PFUser *userToPass = ([convoToPass.user1.username isEqualToString:PFUser.currentUser.username]) ? convoToPass.user2 : convoToPass.user1;
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
