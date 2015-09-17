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
}

@property(nonatomic, retain) IBOutlet CPTGraphHostingView* hostView;

@property(nonatomic, retain) IBOutlet UITableView * playerTableView;

@property(nonatomic, retain) IBOutlet UISearchBar * playerSearchBar;

@property (nonatomic, readwrite, strong) NSMutableArray *dataForPlot;

@property (nonatomic, retain) IBOutlet UIView * playerSearchView;

@property (nonatomic, retain) IBOutlet UIImageView * backButton;

@property (nonatomic, retain) IBOutlet UIImageView * profileImage;

@property (nonatomic, retain) IBOutlet UILabel * playerName;

@property(strong, nonatomic) Player * player;

@property(nonatomic, retain) IBOutlet TabBarView * tabBarView;

@property(nonatomic, retain) IBOutlet UIButton * fitnessButton;

@property(nonatomic, retain) IBOutlet UIButton * riskButton;

@property(nonatomic, retain) IBOutlet UIButton * wellBeingButton;

@property(nonatomic, retain) IBOutlet UILabel * fitnessLabel;

@property(nonatomic, retain) IBOutlet UILabel * riskLabel;

@property(nonatomic, retain) IBOutlet UILabel * wellbeingLabel;

@property(nonatomic, retain) IBOutlet UIScrollView * tabScrollView;

@property(nonatomic, retain) IBOutlet UILabel * dobLabel;

@property(nonatomic, retain) IBOutlet UILabel *weightLabel;

@property(nonatomic, retain) IBOutlet UILabel * heightLabel;

@property(nonatomic, retain) IBOutlet UILabel * capsLabel;

@property(nonatomic, retain) IBOutlet UILabel * debutLabel;

@property(nonatomic, retain) IBOutlet UILabel * ageLabel;

@property(nonatomic, retain) IBOutlet UILabel * riskRatingLabel;
@property (weak, nonatomic) IBOutlet UIView *graphView;

@property(nonatomic, retain) IBOutlet UILabel * positionLabel;

@property(nonatomic, retain) IBOutlet UIButton * changeRiskButton;

@property(nonatomic, retain) IBOutlet UIButton * fitnessIcon;

@property(nonatomic, retain) IBOutlet UIButton * riskIcon;

@property(nonatomic, retain) IBOutlet UIButton * wellbeingIcon;

@property(nonatomic, retain) IBOutlet UILabel * riskChangeLabel;

@property(nonatomic, retain) IBOutlet UIImageView * riskchangeImage;

@property(nonatomic, retain) IBOutlet UILabel * fitnessTabLabel;

@property(nonatomic, retain) IBOutlet UILabel * risTabkLabel;

@property(nonatomic, retain) IBOutlet UILabel * wellbeingTabLabel;

@property(nonatomic, retain) IBOutlet UIScrollView * mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *injuryView;
@property (weak, nonatomic) IBOutlet UIView *fitnessView;
@property (weak, nonatomic) IBOutlet UIView *wellBeingView;

-(IBAction)changeRiskButtonClicked:(id)sender;

-(IBAction)fitnessButtonClicked:(id)sender;

-(IBAction)riskButtonClicked:(id)sender;

-(IBAction)wellBeingButtonClicked:(id)sender;


@end
