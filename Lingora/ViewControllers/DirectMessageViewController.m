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
@import ParseLiveQuery;

@interface DirectMessageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) PFLiveQueryClient *client;
@end

@implementation DirectMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDelegates];
    [self setUpUserProperties];
    [self queryForMessages];
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
}


- (void)queryForMessages {
    PFQuery *convosByThisUser = [self queryForConversationsThisUserCreated];
    PFQuery *convosByOthers = [self queryForConversationsByOtherUser];
    NSArray *queries = [[NSArray alloc] initWithObjects:convosByThisUser, convosByOthers, nil];
    PFQuery *queryMessages = [PFQuery orQueryWithSubqueries:queries];
    NSArray *includeKeys = [[NSArray alloc] initWithObjects:@"messages", @"user1", @"user2", nil];
    [queryMessages includeKeys:includeKeys];
    [queryMessages orderByDescending:@"createdAt"];
    [queryMessages includeKey:@"messages"];
    queryMessages.limit = 20;
    
    // fetch data asynchronously
    [queryMessages findObjectsInBackgroundWithBlock:^(NSArray *conversation, NSError *error) {
        if (conversation != nil) {
            NSLog(@"Successfully got convo");
            if (conversation.count != 0) {
                Conversation *curConvo = conversation[0];
                self.messages = [NSMutableArray arrayWithArray:curConvo.messages];
                [self.tableView reloadData];
            } else {
                // If no convresation has previously existed
                self.messages = [[NSMutableArray alloc] init];
                [Conversation createConversation:self.messages withUser:self.user withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        NSLog(@"Successsfully created a new conversation");
                    } else {
                        NSLog(@"%@", error.localizedDescription);
                    }
                }];
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
    [query whereKey:@"user2" equalTo:self.user.username];
    
    // create subscription
    
    return query;
}


- (PFQuery *)queryForConversationsByOtherUser {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Conversation"];
    [query whereKey:@"username1" equalTo:self.user.username];
    [query whereKey:@"username2" equalTo:PFUser.currentUser.username];
    
    return query;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DirectMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DMCell"];
    cell.messageTextLabel.text = self.messages[indexPath.row][@"messageText"];
    return cell;
}

- (IBAction)didTapSend:(id)sender {
    // create new message and add it to current conversation
    
    Message *newMessage = [Message sendMessage:self.messageTextField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Successfully sent message");
                // clear message field once sent
                self.messageTextField.text = @"";
            } else {
                NSLog(@"Failed to send message");
            }
    }];
    [self.messages addObject:newMessage];
    self.conversation.messages = [NSArray arrayWithArray:self.messages];
    [self.conversation saveInBackground];
}

@end
