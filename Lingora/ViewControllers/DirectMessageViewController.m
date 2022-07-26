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
@end

@implementation DirectMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUserProperties];
    [self setDelegates];
    if (![self.conversation isEqual:nil]) {
        self.messages = [NSMutableArray arrayWithArray:self.conversation.messages];
    } else {
        [self queryForMessages];
    }
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
    [query whereKey:@"user1" equalTo:PFUser.currentUser];
    [query whereKey:@"user1" equalTo:self.user];
    [query whereKey:@"user2" equalTo:PFUser.currentUser];
    [query whereKey:@"user2" equalTo:self.user];
    [query includeKey:@"messages"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *conversation, NSError *error) {
        if (conversation != nil) {
            NSLog(@"Successfully got convo");
            Conversation *curConvo = conversation[0];
            self.messages = [NSMutableArray arrayWithArray:curConvo.messages];
            
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
            
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
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DirectMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DMCell"];
    cell.textLabel.text = self.messages[indexPath.row];
    return cell;
}


@end
