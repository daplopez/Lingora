//
//  ProfileImageCollectionViewCell.h
//  Lingora
//
//  Created by Daphne Lopez on 7/12/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profileImages;

@end

NS_ASSUME_NONNULL_END
