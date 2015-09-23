//
//  RiskView.h
//  Waratahs
//
//  Created by Pruthvi on 20/02/14.
 
//

#import <UIKit/UIKit.h>

@interface RiskView : UIView

@property(nonatomic, weak) IBOutlet UIView * sumofVolView;

@property(nonatomic, weak) IBOutlet UIView * avgSumofVolView;

@property(nonatomic, weak) IBOutlet UILabel * sumofVolLabel;

@property(nonatomic, weak) IBOutlet UILabel * avgsumofVolLabel;

@property(nonatomic, weak) IBOutlet UIView * accEventsView;

@property(nonatomic, weak) IBOutlet UIView * avgAccEventsView;

@property(nonatomic, weak) IBOutlet UILabel * accEventsLabel;

@property(nonatomic, weak) IBOutlet UILabel * avgaccEventsLabel;

@property(nonatomic, weak) IBOutlet UIView * totalDistView;

@property(nonatomic, weak) IBOutlet UIView * avgTotalDistView;

@property(nonatomic, weak) IBOutlet UILabel * totalDistLabel;

@property(nonatomic, weak) IBOutlet UILabel * avgtotalDistLabel;

@property(nonatomic, weak) IBOutlet UIView * forceLoadView;

@property(nonatomic, weak) IBOutlet UIView * avgForceLoadView;

@property(nonatomic, weak) IBOutlet UILabel * forceLoadLabel;

@property(nonatomic, weak) IBOutlet UILabel * avgforceLoadLabel;

@property(nonatomic, weak) IBOutlet UIView * rateofPercExertionView;

@property(nonatomic, weak) IBOutlet UIView * avgRateofPercExertionView;

@property(nonatomic, weak) IBOutlet UILabel * rateofPercExertionLabel;

@property(nonatomic, weak) IBOutlet UILabel * avgrateofPercExertionLabel;

@property(nonatomic, weak) IBOutlet UIView * velchangeLoadView;

@property(nonatomic, weak) IBOutlet UIView * avgVelChangeLoadView;

@property(nonatomic, weak) IBOutlet UILabel * velchangeLoadLabel;

@property(nonatomic, weak) IBOutlet UILabel * avgvelchangeLoadLabel;

@property(nonatomic, weak) IBOutlet UIView * velLoadPerMinView;

@property(nonatomic, weak) IBOutlet UIView * avgLoadPerMinView;

@property(nonatomic, weak) IBOutlet UILabel * velLoadPerMinLabel;

@property(nonatomic, weak) IBOutlet UILabel * avgvelLoadPerMinLabel;

@property(nonatomic, weak) IBOutlet UIView * totalSprintDistView;

@property(nonatomic, weak) IBOutlet UIView * avgTotalSprintDistanceView;

@property(nonatomic, weak) IBOutlet UILabel * totalSprintDistLabel;

@property(nonatomic, weak) IBOutlet UILabel * avgtotalSprintDistLabel;

@property(nonatomic, weak) IBOutlet UIView * overallRiskView;
@property (weak, nonatomic) IBOutlet UILabel *riskRatingChangeLabel;

@property(nonatomic, weak) IBOutlet UILabel * riskCountView;
@property (weak, nonatomic) IBOutlet UIButton *manageRiskButton;
@property (weak, nonatomic) IBOutlet UIView *manageRiskView;

@end
