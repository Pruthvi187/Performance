//
//  WellnessView.h
//  Waratahs
//
//  Created by Pruthvi on 21/02/14.
 
//

#import <UIKit/UIKit.h>

@interface WellnessView : UIView

@property(nonatomic, weak) IBOutlet UIView * sleeplessnessView;

@property(nonatomic, weak) IBOutlet UIView * avgSleeplessnessView;

@property(nonatomic, weak) IBOutlet UILabel * sleeplessLabel;

@property(nonatomic, weak) IBOutlet UILabel * avgSleepQualityLabel;

@property(nonatomic, weak) IBOutlet UIView * legHeavinessView;

@property(nonatomic, weak) IBOutlet UIView * avglegHeavinessView;

@property(nonatomic, weak) IBOutlet UILabel * legHeavinessLabel;

@property(nonatomic, weak) IBOutlet UILabel * avglegHeavinessLabel;

@property(nonatomic, weak) IBOutlet UIView * backPainView;

@property(nonatomic, weak) IBOutlet UIView * avgBackPainView;

@property(nonatomic, weak) IBOutlet UILabel * backPainLabel;

@property(nonatomic, weak) IBOutlet UILabel * avgbackPainLabel;

@property(nonatomic, weak) IBOutlet UIView * calvesView;

@property(nonatomic, weak) IBOutlet UIView * avgCalvesView;

@property(nonatomic, weak) IBOutlet UILabel * calvesLabel;

@property(nonatomic, weak) IBOutlet UILabel * avgcalvesLabel;

@property(nonatomic, weak) IBOutlet UIView * recoveryIndexView;

@property(nonatomic, weak) IBOutlet UIView * avgRecoveryIndexView;

@property(nonatomic, weak) IBOutlet UILabel * recoveryIndexLabel;

@property(nonatomic, weak) IBOutlet UILabel * avgrecoveryIndexLabel;

@property(nonatomic, weak) IBOutlet UIView * muscleSorenessView;

@property(nonatomic, weak) IBOutlet UIView * avgMuscleSorenessView;

@property(nonatomic, weak) IBOutlet UILabel * muscleSorenessLabel;

@property(nonatomic, weak) IBOutlet UILabel * avgmuscleSorenessLabel;

@property(nonatomic, weak) IBOutlet UIView * trainingStateView;

@property(nonatomic, weak) IBOutlet UIView * avgTrainingStateView;

@property(nonatomic, weak) IBOutlet UILabel * trainingStateLabel;

@property(nonatomic, weak) IBOutlet UILabel * avgtrainingStateLabel;

@property(nonatomic, weak) IBOutlet UIView * romTightnessView;

@property(nonatomic, weak) IBOutlet UIView * avgROMTightnessView;

@property(nonatomic, weak) IBOutlet UILabel * romTightnessLabel;

@property(nonatomic, weak) IBOutlet UILabel * avgromTightnessLabel;

@property(nonatomic, weak) IBOutlet UIView * hipflexorQuadView;

@property(nonatomic, weak) IBOutlet UIView * avgHipFlexorQuadView;

@property(nonatomic, weak) IBOutlet UILabel * hipflexorQuadLabel;

@property(nonatomic, weak) IBOutlet UILabel * avghipflexorQuadLabel;

@property(nonatomic, weak) IBOutlet UIView * groinView;

@property(nonatomic, weak) IBOutlet UIView * avgGroinView;

@property(nonatomic, weak) IBOutlet UILabel * groinLabel;

@property(nonatomic, weak) IBOutlet UILabel * avgGroinLabel;

@property(nonatomic, weak) IBOutlet UIView * hamstringView;

@property(nonatomic, weak) IBOutlet UIView * avgHamstringView;

@property(nonatomic, weak) IBOutlet UILabel * hamstringLabel;

@property(nonatomic, weak) IBOutlet UILabel * avghamstringLabel;

@property(nonatomic, weak) IBOutlet UIView * overallWelnessView;

@property(nonatomic, weak) IBOutlet UILabel * wellnessCountView;

@property (weak, nonatomic) IBOutlet UIView *wellnessView;
@property (weak, nonatomic) IBOutlet UILabel *wellnessRatingView;

@end
