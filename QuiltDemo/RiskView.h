//
//  RiskView.h
//  Waratahs
//
//  Created by Pruthvi on 20/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskView : UIView

@property(nonatomic, retain) IBOutlet UIView * sumofVolView;

@property(nonatomic, retain) IBOutlet UIView * avgSumofVolView;

@property(nonatomic, retain) IBOutlet UILabel * sumofVolLabel;

@property(nonatomic, retain) IBOutlet UILabel * avgsumofVolLabel;

@property(nonatomic, retain) IBOutlet UIView * accEventsView;

@property(nonatomic, retain) IBOutlet UIView * avgAccEventsView;

@property(nonatomic, retain) IBOutlet UILabel * accEventsLabel;

@property(nonatomic, retain) IBOutlet UILabel * avgaccEventsLabel;

@property(nonatomic, retain) IBOutlet UIView * totalDistView;

@property(nonatomic, retain) IBOutlet UIView * avgTotalDistView;

@property(nonatomic, retain) IBOutlet UILabel * totalDistLabel;

@property(nonatomic, retain) IBOutlet UILabel * avgtotalDistLabel;

@property(nonatomic, retain) IBOutlet UIView * forceLoadView;

@property(nonatomic, retain) IBOutlet UIView * avgForceLoadView;

@property(nonatomic, retain) IBOutlet UILabel * forceLoadLabel;

@property(nonatomic, retain) IBOutlet UILabel * avgforceLoadLabel;

@property(nonatomic, retain) IBOutlet UIView * rateofPercExertionView;

@property(nonatomic, retain) IBOutlet UIView * avgRateofPercExertionView;

@property(nonatomic, retain) IBOutlet UILabel * rateofPercExertionLabel;

@property(nonatomic, retain) IBOutlet UILabel * avgrateofPercExertionLabel;

@property(nonatomic, retain) IBOutlet UIView * velchangeLoadView;

@property(nonatomic, retain) IBOutlet UIView * avgVelChangeLoadView;

@property(nonatomic, retain) IBOutlet UILabel * velchangeLoadLabel;

@property(nonatomic, retain) IBOutlet UILabel * avgvelchangeLoadLabel;

@property(nonatomic, retain) IBOutlet UIView * velLoadPerMinView;

@property(nonatomic, retain) IBOutlet UIView * avgLoadPerMinView;

@property(nonatomic, retain) IBOutlet UILabel * velLoadPerMinLabel;

@property(nonatomic, retain) IBOutlet UILabel * avgvelLoadPerMinLabel;

@property(nonatomic, retain) IBOutlet UIView * totalSprintDistView;

@property(nonatomic, retain) IBOutlet UIView * avgTotalSprintDistanceView;

@property(nonatomic, retain) IBOutlet UILabel * totalSprintDistLabel;

@property(nonatomic, retain) IBOutlet UILabel * avgtotalSprintDistLabel;

@property(nonatomic, retain) IBOutlet UIView * overallRiskView;

@property(nonatomic, retain) IBOutlet UILabel * riskCountView;

@end
