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

@interface DirectMessageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) NSMutableArray *messages;
@end

@implementation DirectMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDelegates];
}

- (void)setDelegates {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
