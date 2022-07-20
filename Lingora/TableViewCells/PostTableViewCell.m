//
//  PostTableViewCell.m
//  Lingora
//
//  Created by Daphne Lopez on 7/7/22.
//

#import "PostTableViewCell.h"

@implementation PostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (IBAction)didTapProfileButton:(id)sender {
    [self.buttonDelegate didTapProfileButton:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
