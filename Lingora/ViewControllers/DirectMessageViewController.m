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

@interface DirectMessageViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTextFieldTopView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendButtonTopView;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.tableView reloadData];
}


// Move up message field when keyboard shows
-(void) keyboardWillShow:(NSNotification *)notification {
    if(notification.userInfo != nil) {
        if(notification.userInfo[UIKeyboardFrameEndUserInfoKey] != nil) {
            if(self.messageTextField.frame.origin.y > 700) {
                NSValue *value = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
                CGRect rect = value.CGRectValue;
                CGRect viewFrame = self.messageTextField.frame;
                viewFrame.origin.y -= rect.size.height - 64;
                self.messageTextField.frame = viewFrame;
                
                self.messageTextFieldTopView.constant -= rect.size.height - 64;
            }
        }
    }
}

// Hide keyboard and move message field down again
-(void) keyboardWillHide:(NSNotification *)notification {
    if(self.messageTextField.frame.origin.y != 768) {
        CGRect viewFrame = self.messageTextField.frame;
        viewFrame.origin.y = 768;
        self.messageTextField.frame = viewFrame;
        
        self.messageTextFieldTopView.constant = 0;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"Text field was dismissed by the delegate");
    
    [textField resignFirstResponder];
    
    return YES;
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
    self.messageTextField.delegate = self;
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
                        [self liveQuerySetup];
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

    //DL Ediit
    if (!cell) {
        cell = [[DirectMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DMCell"];
        cell.frame = CGRectMake(2, 2, tableView.frame.size.width - 4, 30);
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.borderColor = [UIColor.clearColor CGColor];
    }
    
    [cell.messageTextView removeFromSuperview];
    cell.messageTextView = nil;
    
    Message *message = [self.messages[indexPath.row] fetchIfNeeded];
    
    NSString *senderId = message.author.objectId;
    
    cell.messageTextView = [[UITextView alloc] init];
    cell.messageTextView.text = message[@"messageText"];
    
    // set font and text size (I'm using custom colors here defined in a category)
    [cell.messageTextView setFont:[UIFont fontWithName:@"System" size:14]];
    [cell.messageTextView setTextColor:[UIColor blackColor]];
    
    UIColor *msgColor = ([senderId isEqualToString:PFUser.currentUser.objectId]) ? [UIColor lightGrayColor] : [UIColor greenColor];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.layer.borderColor = [UIColor.clearColor CGColor];
    cell.messageTextView.backgroundColor = msgColor;
    cell.messageTextView.layer.cornerRadius = 10.0;
    
    CGSize newSize = [cell.messageTextView sizeThatFits:CGSizeMake(150, MAXFLOAT)];
    CGRect newFrame;
    
    int msgWidth = 150;
    float originX = ([senderId isEqualToString:PFUser.currentUser.objectId]) ? cell.frame.size.width - msgWidth - 15 : 15;
    
    // set our origin at our calculated x-point, and y position of 10
    newFrame.origin = CGPointMake(originX, 10);

    // set our message width and newly calculated height
    newFrame.size = CGSizeMake(fmaxf(newSize.width, msgWidth), newSize.height);

    // set the frame of our textview and disable scrolling of the textview
    cell.messageTextView.frame = newFrame;
    cell.messageTextView.scrollEnabled  = NO;
    cell.userInteractionEnabled = NO;

    // add our textview to our cell
    [cell addSubview:cell.messageTextView];


    
    // End DL Edit
//    cell.backgroundColor = [UIColor whiteColor];
//    cell.layer.borderColor = [UIColor.clearColor CGColor];
    return cell;
}

// DL Edit
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we need to make sure our cell is tall enough so we don't cut off our message bubble
    DirectMessageTableViewCell *cell = (DirectMessageTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    int msgWidth = 150;
    // get the size of the message for this cell
    CGSize newSize = [cell.messageTextView sizeThatFits:CGSizeMake(msgWidth, MAXFLOAT)];

    // get the height of the bubble and add a little buffer of 20
    CGFloat textHeight  = newSize.height + 20;

    // don't make our cell any smaller than 60
    textHeight = (textHeight < 60) ? 60 : textHeight;

    return textHeight;
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
