//
//  PlayerDetailViewController.h
//  Waratahs
//
//  Created by Pruthvi on 17/02/14.
 
//

#import <UIKit/UIKit.h>
#import <CorePlot/CorePlot-CocoaTouch.h>

@class Player, TabBarView, FitnessView, WellnessView, RiskView, ModelItems;

@interface PlayerDetailViewController : UIViewController<CPTPlotDataSource, CPTPlotDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIViewControllerTransitioningDelegate>
{
    CPTXYGraph * graph;
    NSMutableArray *dataForPlot;
    FitnessView * fitnessView;
    WellnessView * wellnessView;
    RiskView * riskView;

    int avg_sleep_quality;
    NSString *  sleep_quality;
    int avg_leg_heaviness;
    NSString * leg_heaviness;
    int avg_back_pain;
    NSString * back_pain;
    int avg_calves;
    NSString * calves;
    int avg_recovery_index;
    NSString * recovery_index;
    int avg_muscle_soreness;
    NSString * muscle_soreness;
    int avg_training_state;
    NSString * training_state;
    int avg_rom_tightness;
    NSString * rom_tightness;
    int avg_hipflexor_quads;
    NSString * hipflexor_quads;
    int avg_groins;
    NSString * groins;
    int avg_hamstring;
    NSString * hamstrings;
    int avg_sitreach;
    NSString * sitReach;
    int avg_hiprotationl;
    NSString * hipRotationL;
    int avg_hiprotationr;
    NSString * hipRotationR;
    int avg_groinSqueeze0;
    NSString * groinSqueeze0;
    int avg_groinSqueeze60;
    NSString * groinSqueeze60;
    int avg_sumofvol;
    NSString * SumofVol;
    int avg_AcclEvents;
    NSString * AcclEvents;
    int avg_TotalDist;
    NSString * TotalDistance;
    int  avg_percievedExertion;
    NSString * percievedExertion;
    int avg_forceLoadPM;
    NSString * forceLoadPM;
    int avg_velChangeLoad;
    NSString * velChangeLoad;
    int avg_velLoadPM;
    NSString * velLoadPM;
    int avg_TotalSprintDist;
    NSString * totalSprintDistance;
    NSInteger avg_LoadedMarch;
    NSString * loadedMarch;
    NSInteger avg_FireAndMove;
    NSString * fireAndMove;
    NSInteger avg_JerryCanWalk;
    NSString * jerryCanWalk;
    NSInteger avg_BoxLift;
    NSString * box_Lift;
    NSInteger avg_PushUps;
    NSString * pushUps;
    NSInteger avg_sitUps;
    NSString * sitUps;
    NSInteger avg_Run;
    NSString * run;
    NSInteger avg_Walk;
    NSString * walk;
    NSInteger avg_runDodgeJump;
    NSString * runDodgeJump;
    NSInteger avg_EnduranceJump;
    NSString * enduranceJump;
    NSInteger avg_SwimTest;
    NSString * swimTest;
    NSInteger avg_TreadWater;
    NSString * treadWater;
}

@property(nonatomic, weak) IBOutlet CPTGraphHostingView* hostView;

@property(nonatomic, weak) IBOutlet UITableView * playerTableView;

@property(nonatomic, weak) IBOutlet UISearchBar * playerSearchBar;

@property (nonatomic, readwrite, strong) NSMutableArray *dataForPlot;

@property (nonatomic, weak) IBOutlet UIView * playerSearchView;

@property (nonatomic, weak) IBOutlet UIImageView * backButton;

@property (nonatomic, weak) IBOutlet UIImageView * profileImage;

@property (nonatomic, weak) IBOutlet UILabel * playerName;

@property(strong, nonatomic) Player * player;

@property(nonatomic, weak) IBOutlet TabBarView * tabBarView;

@property(nonatomic, weak) IBOutlet UIButton * fitnessButton;

@property(nonatomic, weak) IBOutlet UIButton * riskButton;

@property(nonatomic, weak) IBOutlet UIButton * wellBeingButton;

@property(nonatomic, weak) IBOutlet UILabel * fitnessLabel;

@property(nonatomic, weak) IBOutlet UILabel * riskLabel;

@property(nonatomic, weak) IBOutlet UILabel * wellbeingLabel;

@property(nonatomic, weak) IBOutlet UIScrollView * tabScrollView;

@property(nonatomic, weak) IBOutlet UILabel * dobLabel;

@property(nonatomic, weak) IBOutlet UILabel *weightLabel;

@property(nonatomic, weak) IBOutlet UILabel * heightLabel;

@property(nonatomic, weak) IBOutlet UILabel * PMKeySLabel;

@property(nonatomic, weak) IBOutlet UILabel * HomeUnitLabel;

@property(nonatomic, weak) IBOutlet UILabel * ageLabel;

@property(nonatomic, weak) IBOutlet UILabel * riskRatingLabel;
@property (weak, nonatomic) IBOutlet UIView *graphView;

@property(nonatomic, weak) IBOutlet UILabel * positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *enlistedLabel;

@property(nonatomic, weak) IBOutlet UIButton * changeRiskButton;

@property(nonatomic, weak) IBOutlet UIButton * fitnessIcon;

@property(nonatomic, weak) IBOutlet UIButton * riskIcon;

@property(nonatomic, weak) IBOutlet UIButton * wellbeingIcon;

@property(nonatomic, weak) IBOutlet UILabel * riskChangeLabel;

@property(nonatomic, weak) IBOutlet UIImageView * riskchangeImage;

@property(nonatomic, weak) IBOutlet UILabel * fitnessTabLabel;

@property(nonatomic, weak) IBOutlet UILabel * risTabkLabel;

@property(nonatomic, weak) IBOutlet UILabel * wellbeingTabLabel;

@property(nonatomic, weak) IBOutlet UIScrollView * mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *injuryView;
@property (weak, nonatomic) IBOutlet UIView *fitnessView;
@property (weak, nonatomic) IBOutlet UIView *wellBeingView;
@property (weak, nonatomic) IBOutlet UILabel *injuryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *injuryRiskImage;
@property (weak, nonatomic) IBOutlet UIImageView *fitnessIndicatorImage;
@property (weak, nonatomic) IBOutlet UILabel *fitnessText;
@property (weak, nonatomic) IBOutlet UILabel *wellBeingText;
@property (weak, nonatomic) IBOutlet UIImageView *wellBeingIndicatorImage;

-(IBAction)changeRiskButtonClicked:(id)sender;

-(IBAction)fitnessButtonClicked:(id)sender;

-(IBAction)riskButtonClicked:(id)sender;

-(IBAction)wellBeingButtonClicked:(id)sender;


@end
