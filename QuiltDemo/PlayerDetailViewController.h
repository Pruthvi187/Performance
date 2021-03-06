//
//  PlayerDetailViewController.h
//  Waratahs
//
//  Created by Pruthvi on 17/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot/CorePlot-CocoaTouch.h>

@class Player, TabBarView, FitnessView, WellnessView, RiskView;

@interface PlayerDetailViewController : UIViewController<CPTPlotDataSource, CPTPlotDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
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

@property(nonatomic, retain) IBOutlet UILabel * yearsPlayingLabel;

@property(nonatomic, retain) IBOutlet UILabel * positionLabel;

-(IBAction)fitnessButtonClicked:(id)sender;

-(IBAction)riskButtonClicked:(id)sender;

-(IBAction)wellBeingButtonClicked:(id)sender;


@end
