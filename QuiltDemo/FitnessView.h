//
//  FitnessView.h
//  Waratahs
//
//  Created by Pruthvi on 20/02/14.
 
//

#import <UIKit/UIKit.h>

@interface FitnessView : UIView

@property(nonatomic, weak) IBOutlet UILabel * playerStatusLabel;

@property(nonatomic, weak) IBOutlet UILabel * injurySiteLabel;

@property(nonatomic, weak) IBOutlet UILabel * injuryIncidentlabel;

@property(nonatomic, weak) IBOutlet UILabel * playerTravelLabel;

@property(nonatomic, weak) IBOutlet UILabel * injurySiteText;

@property(nonatomic, weak) IBOutlet UILabel * gamesMissedLabel;

@property(nonatomic, weak) IBOutlet UILabel * injuryIncidentText;

@property(nonatomic, weak) IBOutlet UIView * progressView;

@property(nonatomic, weak) IBOutlet UILabel * riskCountLabel;

@property(nonatomic, weak) IBOutlet UIView * sitReachView;

@property(nonatomic, weak) IBOutlet UIView * avgSitReachView;

@property(nonatomic, weak) IBOutlet UILabel * sitReachCurrent;

@property(nonatomic, weak) IBOutlet UILabel * avgssitReach;

@property(nonatomic, weak) IBOutlet UIView * hipRotationL;

@property(nonatomic, weak) IBOutlet UIView * avgHipRotationLView;

@property(nonatomic, weak) IBOutlet UILabel * hipRotationLCurrent;

@property(nonatomic, weak) IBOutlet UILabel * avghipRotationL;

@property(nonatomic, weak) IBOutlet UIView * hipRotationR;

@property(nonatomic, weak) IBOutlet UIView * avgHipRotationRView;

@property(nonatomic, weak) IBOutlet UILabel * hipRotationRCurrent;

@property(nonatomic, weak) IBOutlet UILabel * avghipRotationR;

@property(nonatomic, weak) IBOutlet UIView * groinSquuze0View;

@property(nonatomic, weak) IBOutlet UIView * avggroinSquuze0View;

@property(nonatomic, weak) IBOutlet UILabel * groinSqueeze0Current;

@property(nonatomic, weak) IBOutlet UILabel * avgGroinSqueeze0;

@property(nonatomic, weak) IBOutlet UIView * groinSquuze60View;

@property(nonatomic, weak) IBOutlet UIView * avgGroinSquuze60View;

@property(nonatomic, weak) IBOutlet UILabel * groinSqueeze60Current;

@property(nonatomic, weak) IBOutlet UILabel * avgGroinSqueeze60;

@property (weak, nonatomic) IBOutlet UIView *fiveKMLoadedMarchReq;

@property (weak, nonatomic) IBOutlet UIView *fiveKMLoadedMarchCurrent;

@property (weak, nonatomic) IBOutlet UIView *fireAndMoveRequirement;

@property (weak, nonatomic) IBOutlet UIView *fireandMoveCurrent;

@property (weak, nonatomic) IBOutlet UIView *jerryCanWalkReq;

@property (weak, nonatomic) IBOutlet UIView *jerryCanWalkCurrent;

@property (weak, nonatomic) IBOutlet UIView *boxLiftReq;
@property (weak, nonatomic) IBOutlet UIView *boxLiftCurrent;

@property (weak, nonatomic) IBOutlet UILabel *fiveKmReqlabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveKmCurrentMarchLabel;

@property (weak, nonatomic) IBOutlet UILabel *fireAndMoveReqLabel;

@property (weak, nonatomic) IBOutlet UILabel *fireAndMoveCurrentLabel;

@property (weak, nonatomic) IBOutlet UILabel *jerryCanWalkReqLabel;
@property (weak, nonatomic) IBOutlet UILabel *jerryCanWalkCurrentLabel;

@property (weak, nonatomic) IBOutlet UILabel *boxLiftReqLabel;
@property (weak, nonatomic) IBOutlet UILabel *boxLiftCurrentLabel;

@property (weak, nonatomic) IBOutlet UIView *runDodgeAndJumReqView;
@property (weak, nonatomic) IBOutlet UIView *runDodgeAndJumpCurrentView;
@property (weak, nonatomic) IBOutlet UILabel *runDodgeAndJumReqlabel;
@property (weak, nonatomic) IBOutlet UILabel *runDodgeAndJumCurrentLabel;

@property (weak, nonatomic) IBOutlet UIView *enduranceMarchReqView;
@property (weak, nonatomic) IBOutlet UIView *enduranceMarchCurrentView;
@property (weak, nonatomic) IBOutlet UILabel *enduranceMarchReqLabel;
@property (weak, nonatomic) IBOutlet UILabel *enduranceMarchCurrentLabel;

@property (weak, nonatomic) IBOutlet UIView *swimCamoflageReqView;
@property (weak, nonatomic) IBOutlet UIView *swimCamoflageCurrentView;
@property (weak, nonatomic) IBOutlet UILabel *swimCamoflageReqLabel;
@property (weak, nonatomic) IBOutlet UILabel *swimCamoflageCurrentLabel;

@property (weak, nonatomic) IBOutlet UIView *treadWaterReqView;
@property (weak, nonatomic) IBOutlet UIView *treadWaterCurrentView;
@property (weak, nonatomic) IBOutlet UILabel *treadWaterReqLabel;
@property (weak, nonatomic) IBOutlet UILabel *treadWaterCurrentLabel;

@property (weak, nonatomic) IBOutlet UIView *pushUpReqView;
@property (weak, nonatomic) IBOutlet UIView *pushupCurrentView;
@property (weak, nonatomic) IBOutlet UILabel *pushUpReqLabel;
@property (weak, nonatomic) IBOutlet UILabel *pushUpCurrentLabel;

@property (weak, nonatomic) IBOutlet UIView *sitUpReqView;
@property (weak, nonatomic) IBOutlet UIView *sitUpCurrentView;
@property (weak, nonatomic) IBOutlet UILabel *sitUpReqLabel;

@property (weak, nonatomic) IBOutlet UILabel *sitUpCurrentLabel;

@property (weak, nonatomic) IBOutlet UIView *twoAndHalfKMRunReq;
@property (weak, nonatomic) IBOutlet UIView *twoAndHalfKMCurrentRun;
@property (weak, nonatomic) IBOutlet UILabel *twoAndHalfKMReqLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoAndHalfKMCurrentLabel;

@property (weak, nonatomic) IBOutlet UIView *fiveKMWalkReqView;
@property (weak, nonatomic) IBOutlet UIView *fiveKMWalkCurrentView;
@property (weak, nonatomic) IBOutlet UILabel *fiveKMWalkReqLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveKMWalkCurrentLabel;


@end
