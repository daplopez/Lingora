//
//  RankInterestsViewController.m
//  Lingora
//
//  Created by Daphne Lopez on 8/5/22.
//

#import "RankInterestsViewController.h"
#import "SceneDelegate.h"
#import "Parse/Parse.h"

@interface RankInterestsViewController ()

@property (weak, nonatomic) IBOutlet UISlider *musicSlider;
@property (weak, nonatomic) IBOutlet UISlider *technologySlider;
@property (weak, nonatomic) IBOutlet UISlider *artSlider;
@property (weak, nonatomic) IBOutlet UISlider *fitnessSlider;
@property (weak, nonatomic) IBOutlet UISlider *outdoorSlider;
@property (weak, nonatomic) IBOutlet UISlider *videoGameSlider;
@property (weak, nonatomic) IBOutlet UISlider *politicsSlider;
@property (weak, nonatomic) IBOutlet UISlider *sportsSlider;
@property (strong, nonatomic) NSMutableArray *sliders;
@end

@implementation RankInterestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSliderArray];
}


- (void)setUpSliderArray {
    self.sliders = [[NSMutableArray alloc] initWithObjects:self.musicSlider, self.technologySlider, self.artSlider, self.fitnessSlider, self.outdoorSlider, self.videoGameSlider, self.politicsSlider, self.politicsSlider, self.sportsSlider, nil];
}

- (IBAction)didTapMusicSlider:(id)sender {
    self.musicSlider = (UISlider *) sender;
    NSLog(@"%f", self.musicSlider.value);

}


- (IBAction)didTapTechnologySlider:(id)sender {
    self.technologySlider = (UISlider *) sender;
}


- (IBAction)didTapArtSlider:(id)sender {
    self.artSlider = (UISlider *) sender;
}


- (IBAction)didTapFitnessSlider:(id)sender {
    self.fitnessSlider = (UISlider *) sender;
}


- (IBAction)didTapOutdoorSlider:(id)sender {
    self.outdoorSlider = (UISlider *) sender;
}


- (IBAction)didTapVideoGamesSlider:(id)sender {
    self.videoGameSlider = (UISlider *) sender;
}


- (IBAction)didTapPoliticsSlider:(id)sender {
    self.politicsSlider = (UISlider *) sender;
}


- (IBAction)didTapSportsSlider:(id)sender {
    self.sportsSlider = (UISlider *) sender;
}


- (IBAction)didTapNext:(id)sender {
    NSMutableArray *rankings = [[NSMutableArray alloc] initWithCapacity:self.sliders.count];
    for (int i = 0; i < self.sliders.count; i++) {
        UISlider *curSlider = self.sliders[i];
        double sliderScore = curSlider.value;
        [rankings addObject:[NSNumber numberWithInt:sliderScore]];
    }
    
    PFUser.currentUser[@"rankedInterests"] = [[NSArray alloc] initWithArray:rankings];
    [PFUser.currentUser saveInBackground];
    
    // Go to the home screen
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
}

@end
