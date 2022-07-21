//
//  RecommendedTableViewCell.h
//  Lingora
//
//  Created by Daphne Lopez on 7/13/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nativeLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *proficiencyLevel;
@property (weak, nonatomic) IBOutlet UILabel *distanceFromUser;
@end

NS_ASSUME_NONNULL_END
