//
//  RiskEditViewController.m
//  Waratahs
//
//  Created by Pruthvi on 25/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "RiskEditViewController.h"
#import "Player.h"
#import "Model.h"
#import "ModelItems.h"
#import "Utilities.h"
#import "Colours.h"

@interface RiskEditViewController ()
{
    int lowestRange;
    int lowerRange;
    int midRange;
    int upperRange;
    int upMostRange;
}

@end

@implementation RiskEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentSumofSliderValue = 42;
    
    [self.riskPercentageLabel setText:[NSString stringWithFormat:@"%@",self.player.RiskRating]];
    
    [self.currentriskPercentageLabel setText:[NSString stringWithFormat:@"%@",self.player.RiskRating]];
    
    Utilities * utilites = [Utilities sharedClient];
    
    NSString * sumofVol = self.model.Sum_ofV2;
    
    int avgSumofVol = (int)floor([utilites getAverageSumofVolume:self.modelItems]);
    
    double sumofVolPC = ([sumofVol intValue]/(double)avgSumofVol);
    
    [self setViewChange:self.currentSumofVolView withPercentage:sumofVolPC];
    
    if(sumofVolPC < 1)
    {
        NSLayoutConstraint * sitReachWidthConstaint = [NSLayoutConstraint constraintWithItem:self.currentSumofVolView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:self.currentSumofVolView.frame.size.width * sumofVolPC];
        [self.view addConstraint:sitReachWidthConstaint];
        lowestRange = [sumofVol intValue];
        midRange = (int)avgSumofVol;
    }
    else
    {
        NSLayoutConstraint * sitReachWidthConstaint = [NSLayoutConstraint constraintWithItem:self.avgSumofVolView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:self.avgSumofVolView.frame.size.width / sumofVolPC];
        [self.view addConstraint:sitReachWidthConstaint];
        midRange = [sumofVol intValue];
        lowestRange = (int)avgSumofVol;
    }
    
    lowerRange = (int)floor((midRange -lowestRange)/2.0) + lowestRange;
    upperRange = midRange + (midRange-lowerRange);
    upMostRange = midRange + (midRange - lowestRange);
    
    [self.avgSumofVolLabel setText:[NSString stringWithFormat:@"%d",avgSumofVol]];
    [self.currentSumofVolLabel setText:[NSString stringWithFormat:@"%@",sumofVol]];
    [self.sumofVolLowestRange setText:[NSString stringWithFormat:@"%d",lowestRange]];
    [self.sumofVolLowerRange setText:[NSString stringWithFormat:@"%d",lowerRange]];
    [self.sumofVolMidRange setText:[NSString stringWithFormat:@"%d", midRange]];
    [self.sumofVolUpperRange setText:[NSString stringWithFormat:@"%d", upperRange]];
    [self.sumofVolUpMostRange setText:[NSString stringWithFormat:@"%d", upMostRange]];
    
    NSString * accEvent = self.model.Sumof_AccTotal;
    
    int avgAcclEvents = (int)floor([utilites getAverageAcceleration:self.modelItems]);
    
    double  acclEventsPC = ([accEvent intValue]/(double)avgAcclEvents);
    
    [self setViewChange:self.currentAcclEvents withPercentage:acclEventsPC];
    
    if(acclEventsPC < 1)
    {
        NSLayoutConstraint * acclEvetnsConstaint = [NSLayoutConstraint constraintWithItem:self.currentAcclEvents attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:self.currentAcclEvents.frame.size.width * acclEventsPC];
        [self.view addConstraint:acclEvetnsConstaint];
        lowestRange = [accEvent intValue];
        midRange = (int)avgAcclEvents;
    }
    else
    {
        NSLayoutConstraint * acclAvgEvetnsConstaint = [NSLayoutConstraint constraintWithItem:self.avgAcclEvents attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:self.avgAcclEvents.frame.size.width / acclEventsPC];
        [self.view addConstraint:acclAvgEvetnsConstaint];
        midRange = [accEvent intValue];
        lowestRange = (int)avgAcclEvents;
    }
    
    lowerRange = (int)floor((midRange -lowestRange)/2.0) + lowestRange;
    upperRange = midRange + (midRange-lowerRange);
    upMostRange = midRange + (midRange - lowestRange);
    
    [self.avgAcclEventsLabel setText:[NSString stringWithFormat:@"%d",avgAcclEvents]];
    [self.currentAcclEventsLabel setText:[NSString stringWithFormat:@"%@",accEvent]];
    [self.acclEventsLowestRange setText:[NSString stringWithFormat:@"%d",lowestRange]];
    [self.acclEventsLowerRange setText:[NSString stringWithFormat:@"%d",lowerRange]];
    [self.acclEventsMidRange setText:[NSString stringWithFormat:@"%d", midRange]];
    [self.acclEventsUpperRange setText:[NSString stringWithFormat:@"%d", upperRange]];
    [self.acclEventsUpMostRange setText:[NSString stringWithFormat:@"%d", upMostRange]];
    
    NSString * sitReach = self.model.SitReach;
    
    int avgSitReach = (int)floor([utilites getAverageSitAndReach:self.modelItems]);
    
    double  sitReachPC = ([sitReach intValue]/(double)avgSitReach);
    
    [self setViewChange:self.currentSitReachView withPercentage:sitReachPC];
    
    if(sitReachPC < 1)
    {
        NSLayoutConstraint * sitReachConstraint = [NSLayoutConstraint constraintWithItem:self.currentSitReachView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:self.currentSitReachView.frame.size.width * sitReachPC];
        [self.view addConstraint:sitReachConstraint];
        lowestRange = [sitReach intValue];
        midRange = (int)avgSitReach;
    }
    else
    {
        NSLayoutConstraint * avgSitReachConstraint = [NSLayoutConstraint constraintWithItem:self.avgSitReachView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:self.avgSitReachView.frame.size.width / sitReachPC];
        [self.view addConstraint:avgSitReachConstraint];
        midRange = [sitReach intValue];
        lowestRange = (int)avgSitReach;
    }
    
    lowerRange = (int)floor((midRange -lowestRange)/2.0) + lowestRange;
    upperRange = midRange + (midRange-lowerRange);
    upMostRange = midRange + (midRange - lowestRange);
    
    [self.avgSitReachLabel setText:[NSString stringWithFormat:@"%d",avgSitReach]];
    [self.currentSitReachLabel setText:[NSString stringWithFormat:@"%@",sitReach]];
    [self.sitReachLowestRange setText:[NSString stringWithFormat:@"%d",lowestRange]];
    [self.sitReachLowerRange setText:[NSString stringWithFormat:@"%d",lowerRange]];
    [self.sitReachMidRange setText:[NSString stringWithFormat:@"%d", midRange]];
    [self.sitReachUpperRange setText:[NSString stringWithFormat:@"%d", upperRange]];
    [self.sitReachUpMostRange setText:[NSString stringWithFormat:@"%d", upMostRange]];
    
    NSString * totalSprDist = self.model.Sum_ofSpr;
    
    int avgSprDist = (int)floor([utilites getAverageTotalSprintDistance:self.modelItems]);
    
    double  totalSprDistPC = ([totalSprDist intValue]/(double)avgSprDist);
    
    [self setViewChange:self.currentSprintDistView withPercentage:totalSprDistPC];
    
    if(totalSprDistPC < 1)
    {
        NSLayoutConstraint * totalSprintDistConstraint = [NSLayoutConstraint constraintWithItem:self.currentSprintDistView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:self.currentSprintDistView.frame.size.width * totalSprDistPC];
        [self.view addConstraint:totalSprintDistConstraint];
        lowestRange = [totalSprDist intValue];
         midRange = (int)avgSprDist;
    }
    else
    {
        NSLayoutConstraint * avgTotalSprintDistanceConstraint = [NSLayoutConstraint constraintWithItem:self.avgSprintDistView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:self.avgSprintDistView.frame.size.width / totalSprDistPC];
        [self.view addConstraint:avgTotalSprintDistanceConstraint];
        
        midRange = [totalSprDist intValue];
        lowestRange = (int)avgSprDist;
    }
    
    lowerRange = (int)floor((midRange -lowestRange)/2.0) + lowestRange;
    upperRange = midRange + (midRange-lowerRange);
    upMostRange = midRange + (midRange - lowestRange);
    
    [self.avgSprintDistLabel setText:[NSString stringWithFormat:@"%d",avgSprDist]];
    [self.currentSprintDistLabel setText:[NSString stringWithFormat:@"%@",totalSprDist]];
    [self.sprintDistLowestRange setText:[NSString stringWithFormat:@"%d",lowestRange]];
    [self.sprintDistLowerRange setText:[NSString stringWithFormat:@"%d",lowerRange]];
    [self.sprintDistMidRange setText:[NSString stringWithFormat:@"%d", midRange]];
    [self.sprintDistUpperRange setText:[NSString stringWithFormat:@"%d", upperRange]];
    [self.sprintDistUpMostRange setText:[NSString stringWithFormat:@"%d", upMostRange]];

    
    NSString * hipRotation = self.model.HipRotation_L;
    
    int avgHipRotaion = (int)floor([utilites getAverageHipRotationL:self.modelItems]);
    
    double  hipRotationPC = ([hipRotation intValue]/(double)avgHipRotaion);
    
    [self setViewChange:self.currentHipRotationView withPercentage:hipRotationPC];
    
    if(hipRotationPC < 1)
    {
        NSLayoutConstraint * hipRotationConstraint = [NSLayoutConstraint constraintWithItem:self.currentHipRotationView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:self.currentHipRotationView.frame.size.width * hipRotationPC];
        [self.view addConstraint:hipRotationConstraint];
        lowestRange = [hipRotation intValue];
        midRange = (int)avgHipRotaion;
    }
    else
    {
        NSLayoutConstraint * avghipRotationConstraint = [NSLayoutConstraint constraintWithItem:self.avgHipRotationView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:self.avgHipRotationView.frame.size.width / hipRotationPC];
        [self.view addConstraint:avghipRotationConstraint];
        midRange = [hipRotation intValue];
        lowestRange = (int)avgHipRotaion;
    }
    
    
    lowerRange = (int)floor((midRange -lowestRange)/2.0) + lowestRange;
    upperRange = midRange + (midRange-lowerRange);
    upMostRange = midRange + (midRange - lowestRange);
    
    [self.avgHipRotationLabel setText:[NSString stringWithFormat:@"%d",avgHipRotaion]];
    [self.currentHipRotationLabel setText:[NSString stringWithFormat:@"%@",hipRotation]];
    [self.hipRotationLowestRange setText:[NSString stringWithFormat:@"%d",lowestRange]];
    [self.hipRotationLowerRange setText:[NSString stringWithFormat:@"%d",lowerRange]];
    [self.hipRotationMidRange setText:[NSString stringWithFormat:@"%d", midRange]];
    [self.hipRotationUpperRange setText:[NSString stringWithFormat:@"%d", upperRange]];
    [self.hipRotationUpMostRange setText:[NSString stringWithFormat:@"%d", upMostRange]];
    

    [self.sumofVolSlider setThumbImage:[UIImage imageNamed:@"change-risk-indicator.png"] forState:UIControlStateNormal];
    [self.acclEventsSlider setThumbImage:[UIImage imageNamed:@"change-risk-indicator.png"] forState:UIControlStateNormal];
    [self.sitReachSlider setThumbImage:[UIImage imageNamed:@"change-risk-indicator.png"] forState:UIControlStateNormal];
    [self.totalSprintSlider setThumbImage:[UIImage imageNamed:@"change-risk-indicator.png"] forState:UIControlStateNormal];
    [self.hipRotationSlider setThumbImage:[UIImage imageNamed:@"change-risk-indicator.png"] forState:UIControlStateNormal];
    
    self.sumofVolSlider.continuous = NO;
    self.acclEventsSlider.continuous = NO;
    self.sitReachSlider.continuous = NO;
    self.totalSprintSlider.continuous = NO;
    self.hipRotationSlider.continuous = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)sumofVolSliderValueChanged:(UISlider*)sender
{
   
    float newStep = roundf((sender.value) / 10.0);
    
    // Convert "steps" back to the context of the sliders values.
    sender.value = newStep * 10.0;
    
    newSumofSliderValue = sender.value;
    
    [self changeRiskValue];

}


-(void)changeRiskValue
{
    if(newSumofSliderValue > currentSumofSliderValue)
    {
        self.riskPercentageLabel.text = [NSString stringWithFormat:@"%d",[self.riskPercentageLabel.text intValue] + (newSumofSliderValue - currentSumofSliderValue)/10];
        currentSumofSliderValue = newSumofSliderValue;
    }
    else if(newSumofSliderValue < currentSumofSliderValue)
    {
        self.riskPercentageLabel.text = [NSString stringWithFormat:@"%d",[self.riskPercentageLabel.text intValue] - (currentSumofSliderValue - newSumofSliderValue)/10];
        currentSumofSliderValue = newSumofSliderValue;
    }
}


-(void) setViewChange:(UIView*)view withPercentage:(float)percentageValue
{
    if(percentageValue < 0.8 && percentageValue >= 0.6)
    {
        [view setBackgroundColor:UIColorFromHex(0xF6691B)];
    }
    else if (percentageValue < 0.6)
    {
        [view setBackgroundColor:[UIColor redColor]];
    }
    else if (percentageValue > 1.2 && percentageValue <= 1.6)
    {
        [view setBackgroundColor:UIColorFromHex(0xF6691B)];
    }
    else if (percentageValue > 1.6)
    {
        [view setBackgroundColor:[UIColor redColor]];
    }
    else if(percentageValue >= 0.8 && percentageValue <= 1.2)
    {
        [view setBackgroundColor:UIColorFromHex(0x53B61D)];
    }

}

@end
