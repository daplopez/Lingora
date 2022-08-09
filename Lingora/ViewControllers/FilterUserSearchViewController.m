//
//  FilterUserSearchViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 8/8/22.
//

#import "FilterUserSearchViewController.h"
#import "FilterInterestsCollectionViewCell.h"

@interface FilterUserSearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *targetLanguageField;
@property (strong, nonatomic) NSMutableArray *interests;
@property (weak, nonatomic) IBOutlet UICollectionView *interestsCollectionView;

@end

@implementation FilterUserSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDelegates];
}

- (void)setDelegates {
    self.interestsCollectionView.delegate = self;
    self.interestsCollectionView.dataSource = self;
}

- (IBAction)didTapAddInterest:(id)sender {
    // create the actual alert controller view that will be the pop-up
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Interests" message:@"Add an interest below:" preferredStyle:(UIAlertControllerStyleAlert)];

    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Interest";
    }];


    // add the buttons/actions to the view controller
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];

    // add the cancel action to the alertController
    [alert addAction:cancelAction];

    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (self.interests != nil) {
            [self.interests addObject:alert.textFields[0].text];
        } else {
            self.interests = [[NSMutableArray alloc] initWithObjects:alert.textFields[0].text, nil];
        }
        [self.interestsCollectionView reloadData];
        
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)didTapSearch:(id)sender {
    __weak typeof(self) weakSelf = self;
    [weakSelf.delegate sendFiltersBack:self.targetLanguageField.text withRange:self.locationField.text interests:self.interests];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.interests.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterInterestsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterInterestsCell" forIndexPath:indexPath];
    
    NSString *interest = self.interests[indexPath.row];
    cell.interestLabel.text = interest;
    return cell;
}

@end
