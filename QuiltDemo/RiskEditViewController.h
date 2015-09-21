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

@property(nonatomic, weak) IBOutlet UILabel * riskPercentageLabel;

@property(nonatomic, weak) IBOutlet UILabel * currentriskPercentageLabel;

@property(nonatomic, weak) IBOutlet UISlider * sumofVolSlider;

@property(nonatomic, weak) IBOutlet UISlider * acclEventsSlider;

@property(nonatomic, weak) IBOutlet UISlider * sitReachSlider;

@property(nonatomic, weak) IBOutlet UISlider * totalSprintSlider;

@property(nonatomic, weak) IBOutlet UISlider * hipRotationSlider;

@property(nonatomic, weak) IBOutlet UIView * avgSumofVolView;

@property(nonatomic, weak) IBOutlet UILabel * avgSumofVolLabel;

@property(nonatomic, weak) IBOutlet UIView * currentSumofVolView;

@property(nonatomic, weak) IBOutlet UILabel * currentSumofVolLabel;

@property(nonatomic, weak) IBOutlet UIView * avgAcclEvents;

@property(nonatomic, weak) IBOutlet UILabel * avgAcclEventsLabel;

@property(nonatomic, weak) IBOutlet UIView * currentAcclEvents;

@property(nonatomic, weak) IBOutlet UILabel * currentAcclEventsLabel;

@property(nonatomic, weak) IBOutlet UIView * avgSitReachView;

@property(nonatomic, weak) IBOutlet UILabel * avgSitReachLabel;

@property(nonatomic, weak) IBOutlet UIView * currentSitReachView;

@property(nonatomic, weak) IBOutlet UILabel * currentSitReachLabel;

@property(nonatomic, weak) IBOutlet UIView * avgSprintDistView;

@property(nonatomic, weak) IBOutlet UILabel * avgSprintDistLabel;

@property(nonatomic, weak) IBOutlet UIView * currentSprintDistView;

@property(nonatomic, weak) IBOutlet UILabel * currentSprintDistLabel;

@property(nonatomic, weak) IBOutlet UIView * avgHipRotationView;

@property(nonatomic, weak) IBOutlet UILabel * avgHipRotationLabel;

@property(nonatomic, weak) IBOutlet UIView * currentHipRotationView;

@property(nonatomic, weak) IBOutlet UILabel * currentHipRotationLabel;

@property(nonatomic, weak) IBOutlet UILabel * sumofVolLowestRange;

@property(nonatomic, weak) IBOutlet UILabel * sumofVolLowerRange;

@property(nonatomic, weak) IBOutlet UILabel * sumofVolMidRange;

@property(nonatomic, weak) IBOutlet UILabel * sumofVolUpperRange;

@property(nonatomic, weak) IBOutlet UILabel * sumofVolUpMostRange;

@property(nonatomic, weak) IBOutlet UILabel * acclEventsLowestRange;

@property(nonatomic, weak) IBOutlet UILabel * acclEventsLowerRange;

@property(nonatomic, weak) IBOutlet UILabel * acclEventsMidRange;

@property(nonatomic, weak) IBOutlet UILabel * acclEventsUpperRange;

@property(nonatomic, weak) IBOutlet UILabel * acclEventsUpMostRange;

@property(nonatomic, weak) IBOutlet UILabel * sitReachLowestRange;

@property(nonatomic, weak) IBOutlet UILabel * sitReachLowerRange;

@property(nonatomic, weak) IBOutlet UILabel * sitReachMidRange;

@property(nonatomic, weak) IBOutlet UILabel * sitReachUpperRange;

@property(nonatomic, weak) IBOutlet UILabel * sitReachUpMostRange;

@property(nonatomic, weak) IBOutlet UILabel * sprintDistLowestRange;

@property(nonatomic, weak) IBOutlet UILabel * sprintDistLowerRange;

@property(nonatomic, weak) IBOutlet UILabel * sprintDistMidRange;

@property(nonatomic, weak) IBOutlet UILabel * sprintDistUpperRange;

@property(nonatomic, weak) IBOutlet UILabel * sprintDistUpMostRange;

@property(nonatomic, weak) IBOutlet UILabel * hipRotationLowestRange;

@property(nonatomic, weak) IBOutlet UILabel * hipRotationLowerRange;

@property(nonatomic, weak) IBOutlet UILabel * hipRotationMidRange;

@property(nonatomic, weak) IBOutlet UILabel * hipRotationUpperRange;

@property(nonatomic, weak) IBOutlet UILabel * hipRotationUpMostRange;

@property(nonatomic, weak) IBOutlet UILabel * riskChangeLabel;

@property(nonatomic, weak) IBOutlet UIImageView * riskchangeImage;
@property (weak, nonatomic) IBOutlet UIView *currentInjuryView;
@property (weak, nonatomic) IBOutlet UIView *changedInjuryView;

@property(strong, nonatomic) Player * player;

@property(strong, nonatomic) Model * model;

@property(strong, nonatomic) ModelItems * modelItems;

-(IBAction)closeButtonPressed:(id)sender;


@end
