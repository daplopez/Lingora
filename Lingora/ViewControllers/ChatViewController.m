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

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *conversations;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self queryForConversations];
}


- (void)queryForConversations {
    PFQuery *query = [PFQuery queryWithClassName:@"Conversation"];
    [query whereKey:@"user1" equalTo:PFUser.currentUser];
    [query whereKey:@"user2" equalTo:PFUser.currentUser];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *conversations, NSError *error) {
        if (conversations != nil) {
            NSLog(@"Successfully got users");
            
            self.conversations = [NSArray arrayWithArray:conversations];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    Conversation *curConvo = self.conversations[indexPath.row];
    PFUser *user = [curConvo.user1 isEqual:PFUser.currentUser] ? curConvo.user2 : curConvo.user1;
    cell.profilePicture.file = user[@"image"];
    [cell.profilePicture loadInBackground];
    cell.nameLabel.text = user[@"fullName"];
    cell.messageLabel.text = curConvo.messages[curConvo.messages.count - 1];
    return cell;
}

 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"SearchToDM"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
         Conversation *dataToPass = self.conversations[indexPath.row];
         NSLog(@"\n%@\n", dataToPass);
         DirectMessageViewController *messageVC = (DirectMessageViewController *) [segue destinationViewController];
         messageVC.conversation = dataToPass;
     }
 }


@end
