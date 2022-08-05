//
//  DirectMessageViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 7/25/22.
//

#import "DirectMessageViewController.h"
#import "Conversation.h"
#import "Message.h"
#import "DirectMessageTableViewCell.h"
#import "Parse/PFImageView.h"
#import "UIScrollView+EmptyDataSet.h"
@import ParseLiveQuery;

@interface DirectMessageViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) PFLiveQueryClient *client;
@property (strong, nonatomic) PFQuery *query;
@property (strong, nonatomic) PFLiveQuerySubscription *subscription;
@end

@implementation DirectMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDelegates];
    [self setUpUserProperties];
    if (self.conversation != nil) {
        self.messages = [NSMutableArray arrayWithArray:self.conversation.messages];
        [self liveQuerySetup];
    } else {
        [self queryForConversation];
        
    }
    
    [self.tableView reloadData];
}



- (void)setUpUserProperties {
    self.profileImage.file = self.user[@"image"];
    [self.profileImage loadInBackground];
    self.nameLabel.text = self.user[@"fullName"];
    self.usernameLabel.text = self.user[@"username"];
}

- (void)setDelegates {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}


- (void)queryForConversation {
    PFQuery *convosByThisUser = [self queryForConversationsThisUserCreated];
    PFQuery *convosByOthers = [self queryForConversationsByOtherUser];
    NSArray *queries = [[NSArray alloc] initWithObjects:convosByThisUser, convosByOthers, nil];
    PFQuery *queryMessages = [PFQuery orQueryWithSubqueries:queries];
    NSArray *includeKeys = [[NSArray alloc] initWithObjects:@"messages", @"usersInConversation", nil];
    [queryMessages includeKeys:includeKeys];
    [queryMessages orderByDescending:@"createdAt"];
    queryMessages.limit = 20;
    
    // fetch data asynchronously
    [queryMessages findObjectsInBackgroundWithBlock:^(NSArray *conversation, NSError *error) {
        if (conversation != nil) {
            NSLog(@"Successfully got convo");
            if (conversation.count != 0) {
                Conversation *curConvo = conversation[0];
                self.conversation = curConvo;
                self.messages = [NSMutableArray arrayWithArray:curConvo.messages];
                [self liveQuerySetup];
                [self.tableView reloadData];
            } else {
                // If no convresation has previously existed
                self.messages = [[NSMutableArray alloc] init];
                self.conversation = [Conversation createConversation:self.messages withUser:self.user withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        NSLog(@"Successsfully created a new conversation");
                    } else {
                        NSLog(@"%@", error.localizedDescription);
                    }
                }];
                [self liveQuerySetup];
            }
            
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (PFQuery *)queryForConversationsThisUserCreated {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Conversation"];
    [query whereKey:@"username1" equalTo:PFUser.currentUser.username];
    [query whereKey:@"username2" equalTo:self.user.username];
        
    return query;
}


- (PFQuery *)queryForConversationsByOtherUser {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Conversation"];
    [query whereKey:@"username1" equalTo:self.user.username];
    [query whereKey:@"username2" equalTo:PFUser.currentUser.username];
    
    return query;
}


- (void)runAllMessagesQuery {
    self.query = [self queryForMessagesBetweenTwoUsers];
    
    // fetch data asynchronously
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error) {
        if (messages != nil) {
            NSLog(@"Successfully got messages");
            [self liveQuerySetup];
            self.messages = [NSMutableArray arrayWithArray:messages];
            
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (PFQuery *)queryForMessagesBetweenTwoUsers {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"convoID" equalTo:self.conversation.objectId];
    
    //NSArray *includeKeys = [[NSArray alloc] initWithObjects:@"author", nil];
    //[query includeKeys:includeKeys];
    [query orderByDescending:@"createdAt"];
    
    return query;
}


- (void)liveQuerySetup {
    self.client = [[PFLiveQueryClient alloc] init];
    self.query = [self queryForMessagesBetweenTwoUsers];
    self.subscription = [[self.client subscribeToQuery:self.query] addCreateHandler:^(PFQuery *query, PFObject *object) {
        Message *message = [(Message *)object fetchIfNeeded];;
        //message = [message fetchIfNeeded];
        message.author = [message.author fetchIfNeeded];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messages addObject:message];
            self.conversation.messages = [NSArray arrayWithArray:self.messages];
            [self.conversation saveInBackground];
            [self.tableView reloadData];
        });
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DirectMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DMCell"];
    Message *message = [self.messages[indexPath.row] fetchIfNeeded];
    cell.messageTextLabel.text = message[@"messageText"];
    cell.senderNameLabel.text = message.username;
    return cell;
}

- (IBAction)didTapSend:(id)sender {
    // create new message
    [Message sendMessage:self.messageTextField.text conversation:self.conversation withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Successfully sent message");
                // clear message field once sent
                //[self liveQuerySetup];
                self.messageTextField.text = @"";
            } else {
                NSLog(@"Failed to send message");
            }
    }];
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
    NSString *text = @"No messages to display";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Send a new message to start the conversation!";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
