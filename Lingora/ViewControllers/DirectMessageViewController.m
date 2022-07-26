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

@interface DirectMessageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@end

@implementation DirectMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDelegates];
    [self setUpUserProperties];
    // If opened DM from any other screen, query for a conversation between the two users
    if (self.conversation == nil) {
        [self queryForMessages];
    // If conversation was selected from chat vc, then messages already exist
    } else {
        self.messages = [NSMutableArray arrayWithArray:self.conversation.messages];
        [self.tableView reloadData];
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
}


- (void)queryForMessages {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Conversation"];
    [query orderByDescending:@"createdAt"];
    NSArray *includeKeys = [[NSArray alloc] initWithObjects:@"messages", @"user1", @"user2", nil];
    [query includeKeys:includeKeys];
    [query whereKey:@"user1" equalTo:PFUser.currentUser];
    // [query whereKey:@"user1" equalTo:self.user];
    //[query whereKey:@"user2" equalTo:PFUser.currentUser];
    //[query whereKey:@"user2" equalTo:self.user];
    //[query includeKey:@"messages"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *conversation, NSError *error) {
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
