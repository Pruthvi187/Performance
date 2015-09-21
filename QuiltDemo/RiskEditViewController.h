//
//  RiskEditViewController.h
//  Waratahs
//
//  Created by Pruthvi on 25/02/14.
 
//

#import <UIKit/UIKit.h>

@class Player, Model, ModelItems;

@interface RiskEditViewController : UIViewController
{
    int currentSumofSliderValue;
    int newSumofSliderValue;
}

@property(nonatomic, retain) IBOutlet UILabel * riskPercentageLabel;

@property(nonatomic, retain) IBOutlet UILabel * currentriskPercentageLabel;

@property(nonatomic, retain) IBOutlet UISlider * sumofVolSlider;

@property(nonatomic, retain) IBOutlet UISlider * acclEventsSlider;

@property(nonatomic, retain) IBOutlet UISlider * sitReachSlider;

@property(nonatomic, retain) IBOutlet UISlider * totalSprintSlider;

@property(nonatomic, retain) IBOutlet UISlider * hipRotationSlider;

@property(nonatomic, retain) IBOutlet UIView * avgSumofVolView;

@property(nonatomic, retain) IBOutlet UILabel * avgSumofVolLabel;

@property(nonatomic, retain) IBOutlet UIView * currentSumofVolView;

@property(nonatomic, retain) IBOutlet UILabel * currentSumofVolLabel;

@property(nonatomic, retain) IBOutlet UIView * avgAcclEvents;

@property(nonatomic, retain) IBOutlet UILabel * avgAcclEventsLabel;

@property(nonatomic, retain) IBOutlet UIView * currentAcclEvents;

@property(nonatomic, retain) IBOutlet UILabel * currentAcclEventsLabel;

@property(nonatomic, retain) IBOutlet UIView * avgSitReachView;

@property(nonatomic, retain) IBOutlet UILabel * avgSitReachLabel;

@property(nonatomic, retain) IBOutlet UIView * currentSitReachView;

@property(nonatomic, retain) IBOutlet UILabel * currentSitReachLabel;

@property(nonatomic, retain) IBOutlet UIView * avgSprintDistView;

@property(nonatomic, retain) IBOutlet UILabel * avgSprintDistLabel;

@property(nonatomic, retain) IBOutlet UIView * currentSprintDistView;

@property(nonatomic, retain) IBOutlet UILabel * currentSprintDistLabel;

@property(nonatomic, retain) IBOutlet UIView * avgHipRotationView;

@property(nonatomic, retain) IBOutlet UILabel * avgHipRotationLabel;

@property(nonatomic, retain) IBOutlet UIView * currentHipRotationView;

@property(nonatomic, retain) IBOutlet UILabel * currentHipRotationLabel;

@property(nonatomic, retain) IBOutlet UILabel * sumofVolLowestRange;

@property(nonatomic, retain) IBOutlet UILabel * sumofVolLowerRange;

@property(nonatomic, retain) IBOutlet UILabel * sumofVolMidRange;

@property(nonatomic, retain) IBOutlet UILabel * sumofVolUpperRange;

@property(nonatomic, retain) IBOutlet UILabel * sumofVolUpMostRange;

@property(nonatomic, retain) IBOutlet UILabel * acclEventsLowestRange;

@property(nonatomic, retain) IBOutlet UILabel * acclEventsLowerRange;

@property(nonatomic, retain) IBOutlet UILabel * acclEventsMidRange;

@property(nonatomic, retain) IBOutlet UILabel * acclEventsUpperRange;

@property(nonatomic, retain) IBOutlet UILabel * acclEventsUpMostRange;

@property(nonatomic, retain) IBOutlet UILabel * sitReachLowestRange;

@property(nonatomic, retain) IBOutlet UILabel * sitReachLowerRange;

@property(nonatomic, retain) IBOutlet UILabel * sitReachMidRange;

@property(nonatomic, retain) IBOutlet UILabel * sitReachUpperRange;

@property(nonatomic, retain) IBOutlet UILabel * sitReachUpMostRange;

@property(nonatomic, retain) IBOutlet UILabel * sprintDistLowestRange;

@property(nonatomic, retain) IBOutlet UILabel * sprintDistLowerRange;

@property(nonatomic, retain) IBOutlet UILabel * sprintDistMidRange;

@property(nonatomic, retain) IBOutlet UILabel * sprintDistUpperRange;

@property(nonatomic, retain) IBOutlet UILabel * sprintDistUpMostRange;

@property(nonatomic, retain) IBOutlet UILabel * hipRotationLowestRange;

@property(nonatomic, retain) IBOutlet UILabel * hipRotationLowerRange;

@property(nonatomic, retain) IBOutlet UILabel * hipRotationMidRange;

@property(nonatomic, retain) IBOutlet UILabel * hipRotationUpperRange;

@property(nonatomic, retain) IBOutlet UILabel * hipRotationUpMostRange;

@property(nonatomic, retain) IBOutlet UILabel * riskChangeLabel;

@property(nonatomic, retain) IBOutlet UIImageView * riskchangeImage;
@property (weak, nonatomic) IBOutlet UIView *currentInjuryView;
@property (weak, nonatomic) IBOutlet UIView *changedInjuryView;

@property(strong, nonatomic) Player * player;

@property(strong, nonatomic) Model * model;

@property(strong, nonatomic) ModelItems * modelItems;

-(IBAction)closeButtonPressed:(id)sender;


@end
