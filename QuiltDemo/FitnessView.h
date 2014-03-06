//
//  FitnessView.h
//  Waratahs
//
//  Created by Pruthvi on 20/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FitnessView : UIView

@property(nonatomic, retain) IBOutlet UILabel * playerStatusLabel;

@property(nonatomic, retain) IBOutlet UILabel * injurySiteLabel;

@property(nonatomic, retain) IBOutlet UILabel * injuryIncidentlabel;

@property(nonatomic, retain) IBOutlet UILabel * playerTravelLabel;

@property(nonatomic, retain) IBOutlet UILabel * injurySiteText;

@property(nonatomic, retain) IBOutlet UILabel * gamesMissedLabel;

@property(nonatomic, retain) IBOutlet UILabel * injuryIncidentText;

@property(nonatomic, retain) IBOutlet UIView * progressView;

@property(nonatomic, retain) IBOutlet UILabel * riskCountLabel;

@property(nonatomic, retain) IBOutlet UIView * sitReachView;

@property(nonatomic, retain) IBOutlet UIView * avgSitReachView;

@property(nonatomic, retain) IBOutlet UILabel * sitReachCurrent;

@property(nonatomic, retain) IBOutlet UILabel * avgssitReach;

@property(nonatomic, retain) IBOutlet UIView * hipRotationL;

@property(nonatomic, retain) IBOutlet UIView * avgHipRotationLView;

@property(nonatomic, retain) IBOutlet UILabel * hipRotationLCurrent;

@property(nonatomic, retain) IBOutlet UILabel * avghipRotationL;

@property(nonatomic, retain) IBOutlet UIView * hipRotationR;

@property(nonatomic, retain) IBOutlet UIView * avgHipRotationRView;

@property(nonatomic, retain) IBOutlet UILabel * hipRotationRCurrent;

@property(nonatomic, retain) IBOutlet UILabel * avghipRotationR;

@property(nonatomic, retain) IBOutlet UIView * groinSquuze0View;

@property(nonatomic, retain) IBOutlet UIView * avggroinSquuze0View;

@property(nonatomic, retain) IBOutlet UILabel * groinSqueeze0Current;

@property(nonatomic, retain) IBOutlet UILabel * avgGroinSqueeze0;

@property(nonatomic, retain) IBOutlet UIView * groinSquuze60View;

@property(nonatomic, retain) IBOutlet UIView * avgGroinSquuze60View;

@property(nonatomic, retain) IBOutlet UILabel * groinSqueeze60Current;

@property(nonatomic, retain) IBOutlet UILabel * avgGroinSqueeze60;


@end
