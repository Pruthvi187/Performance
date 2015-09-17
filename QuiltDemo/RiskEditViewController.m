//
//  RiskEditViewController.m
//  Waratahs
//
//  Created by Pruthvi on 25/02/14.
 
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
    

    CGRect sumofV1Frame;
    
    
    if(sumofVolPC < 1)
    {
        sumofV1Frame = self.currentSumofVolView.frame;
        sumofV1Frame.size.width = sumofV1Frame.size.width * sumofVolPC;
        sumofV1Frame.size.height = sumofV1Frame.size.height;
        [self.currentSumofVolView setFrame:sumofV1Frame];
        lowestRange = [sumofVol intValue];
        midRange = (int)avgSumofVol;
        self.sumofVolSlider.value = 0;
    }
    else
    {
        sumofV1Frame = self.avgSumofVolView.frame;
        sumofV1Frame.size.width = sumofV1Frame.size.width / sumofVolPC;
        sumofV1Frame.size.height = sumofV1Frame.size.height;
        [self.avgSumofVolView setFrame:sumofV1Frame];
        midRange = [sumofVol intValue];
        lowestRange = (int)avgSumofVol;
         self.sumofVolSlider.value = 20;
    }
    
    lowerRange = (int)floor((midRange -lowestRange)/2.0) + lowestRange;
    upperRange = midRange + (midRange-lowerRange);
    upMostRange = midRange + (midRange - lowestRange);
    
    if(sumofVolPC == 1.0)
    {
        lowestRange = (int)floor([sumofVol intValue]/4.0);
        lowerRange = (int)floor([sumofVol intValue]/2.0);
        upperRange = (midRange+lowestRange);
        upMostRange = (midRange + lowerRange);
        
    }
    
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
    
    CGRect acclEventsFrame;
    
    if(acclEventsPC < 1)
    {
        acclEventsFrame = self.currentAcclEvents.frame;
        acclEventsFrame.size.width = acclEventsFrame.size.width * acclEventsPC;
        acclEventsFrame.size.height = acclEventsFrame.size.height;
        [self.currentAcclEvents setFrame:acclEventsFrame];
        lowestRange = [accEvent intValue];
        midRange = (int)avgAcclEvents;
        self.acclEventsSlider.value = 0;
    }
    else
    {
        acclEventsFrame = self.avgAcclEvents.frame;
        acclEventsFrame.size.width = acclEventsFrame.size.width / acclEventsPC;
        acclEventsFrame.size.height = acclEventsFrame.size.height;
        [self.avgAcclEvents setFrame:acclEventsFrame];
        midRange = [accEvent intValue];
        lowestRange = (int)avgAcclEvents;
        self.acclEventsSlider.value = 20;
    }
    
    lowerRange = (int)floor((midRange -lowestRange)/2.0) + lowestRange;

    upperRange = midRange + (midRange-lowerRange);
    upMostRange = midRange + (midRange - lowestRange);
    
    if(acclEventsPC == 1.0)
    {
        lowestRange = (int)floor([accEvent intValue]/4.0);
        lowerRange = (int)floor([accEvent intValue]/2.0);
        upperRange = (midRange+lowestRange);
        upMostRange = (midRange + lowerRange);
        
    }
    
    
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
    
    CGRect sitReachWidthFrame;
    
    if(sitReachPC < 1)
    {
        sitReachWidthFrame = self.currentSitReachView.frame;
        sitReachWidthFrame.size.width = sitReachWidthFrame.size.width * sitReachPC;
        sitReachWidthFrame.size.height = sitReachWidthFrame.size.height;
        [self.currentSitReachView setFrame:sitReachWidthFrame];
        lowestRange = [sitReach intValue];
        midRange = (int)avgSitReach;
        self.sitReachSlider.value = 0;
    }
    else
    {
        sitReachWidthFrame = self.avgSitReachView.frame;
        sitReachWidthFrame.size.width = sitReachWidthFrame.size.width / sitReachPC;
        sitReachWidthFrame.size.height = sitReachWidthFrame.size.height;
        [self.avgSitReachView setFrame:sitReachWidthFrame];
        midRange = [sitReach intValue];
        lowestRange = (int)avgSitReach;
        self.sitReachSlider.value = 20;
    }
    
    lowerRange = (int)floor((midRange -lowestRange)/2.0) + lowestRange;
    upperRange = midRange + (midRange-lowerRange);
    upMostRange = midRange + (midRange - lowestRange);
    
    if(sitReachPC == 1.0)
    {
        lowestRange = (int)floor([sitReach intValue]/4.0);
        lowerRange = (int)floor([sitReach intValue]/2.0);
        upperRange = (midRange+lowestRange);
        upMostRange = (midRange + lowerRange);
        
    }
    
    
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
    
    CGRect currentSprintDistFrame;
    
    if(totalSprDistPC < 1)
    {
        currentSprintDistFrame = self.currentSprintDistView.frame;
        currentSprintDistFrame.size.width = currentSprintDistFrame.size.width * totalSprDistPC;
        currentSprintDistFrame.size.height = currentSprintDistFrame.size.height;
        [self.currentSprintDistView setFrame:currentSprintDistFrame];
        lowestRange = [totalSprDist intValue];
        midRange = (int)avgSprDist;
        self.totalSprintSlider.value = 0;
    }
    else
    {
        currentSprintDistFrame = self.avgSprintDistView.frame;
        currentSprintDistFrame.size.width = currentSprintDistFrame.size.width / totalSprDistPC;
        currentSprintDistFrame.size.height = currentSprintDistFrame.size.height;
        [self.avgSprintDistView setFrame:currentSprintDistFrame];
        midRange = [totalSprDist intValue];
        lowestRange = (int)avgSprDist;
        self.totalSprintSlider.value = 20;
    }
    
    lowerRange = (int)floor((midRange -lowestRange)/2.0) + lowestRange;
    
    upperRange = midRange + (midRange-lowerRange);
    upMostRange = midRange + (midRange - lowestRange);
    
    if(totalSprDistPC == 1.0)
    {
        lowestRange = (int)floor([totalSprDist intValue]/4.0);
        lowerRange = (int)floor([totalSprDist intValue]/2.0);
        upperRange = (midRange+lowestRange);
        upMostRange = (midRange + lowerRange);
   
    }
    
    
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
    
    
    CGRect hipRotationFrame;
    
    if(hipRotationPC < 1)
    {
        hipRotationFrame = self.currentHipRotationView.frame;
        hipRotationFrame.size.width = hipRotationFrame.size.width * hipRotationPC;
        hipRotationFrame.size.height = hipRotationFrame.size.height;
        [self.currentHipRotationView setFrame:hipRotationFrame];
        lowestRange = [hipRotation intValue];
        midRange = (int)avgHipRotaion;
        self.hipRotationSlider.value = 0;
    }
    else
    {
        hipRotationFrame = self.avgHipRotationView.frame;
        hipRotationFrame.size.width = hipRotationFrame.size.width / hipRotationPC;
        hipRotationFrame.size.height = hipRotationFrame.size.height;
        [self.avgHipRotationView setFrame:hipRotationFrame];
        midRange = [hipRotation intValue];
        lowestRange = (int)avgHipRotaion;
        self.hipRotationSlider.value = 20;
    }
    
   
   
    lowerRange = (int)floor((midRange -lowestRange)/2.0) + lowestRange;
    upperRange = midRange + (midRange-lowerRange);
    upMostRange = midRange + (midRange - lowestRange);
    
    if(hipRotationPC == 1.0)
    {
        lowestRange = (int)floor([hipRotation intValue]/4.0);
        lowerRange = (int)floor([hipRotation intValue]/2.0);
        midRange = [hipRotation intValue];
        upperRange = (midRange+lowestRange);
        upMostRange = (midRange + lowerRange);
    }
    
    
    [self.riskChangeLabel setText:[NSString stringWithFormat:@"%@%@",self.player.RiskRatingChange,@"%"]];
    
    if([self.player.RiskRatingChange intValue] < 0)
    {
        [self.riskchangeImage setImage:[UIImage imageNamed:@"icon-triangle-down-green"]];
        [self.riskChangeLabel setTextColor:UIColorFromHex(0x53B61D)];
    }
    else
    {
        [self.riskchangeImage setImage:[UIImage imageNamed:@"icon-triangle-up-red"]];
        [self.riskChangeLabel setTextColor:[UIColor redColor]];
    }
    
 
    
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
