//
//  Utilities.h
//  Waratahs
//
//  Created by Pruthvi on 18/02/14.
 
//

#import <Foundation/Foundation.h>

@class WellnessPlayers, ModelItems, PlayerItems;



@interface Utilities : NSObject

+(Utilities *) sharedClient;

-(NSString *) getFilePath:(NSString *) fileName ofType:(NSString *)type;

-(PlayerItems*) getSortedPlayerItems:(NSString*) sortType withSortKind:(BOOL)ascending withPlayers:(NSMutableArray*)players;

-(double) getAverageSleepQuality:(WellnessPlayers*)wellness;

-(double) getAverageLegHeaviness:(WellnessPlayers*)wellness;

-(double) getAverageBackPain:(WellnessPlayers*)wellness;

-(double) getAverageCalves:(WellnessPlayers*)wellness;

-(double) getAverageRecoveryIndex:(WellnessPlayers*)wellness;

-(double) getAverageMuscleSoreness:(WellnessPlayers*)wellness;

-(double) getAverageTrainingState:(WellnessPlayers*)wellness;

-(double) getAverageROMTightness:(WellnessPlayers*)wellness;

-(double) getAverageHipFlexorQuad:(WellnessPlayers*)wellness;

-(double) getAverageGroin:(WellnessPlayers*)wellness;

-(double) getAverageHamstrings:(WellnessPlayers*)wellness;

-(double) getAverageSumofVolume:(ModelItems*)modelItems;

-(double) getAverageAcceleration:(ModelItems*)modelItems;

-(double) getAverageTotalDistance:(ModelItems*)modelItems;

-(double) getAverageForceLoadPM:(ModelItems*)modelItems;

-(double) getAveragePercievedExertionRate:(WellnessPlayers*)wellnessItems;

-(double) getAverageVelocityChangeLoad:(ModelItems*)modelItems;

-(double) getAverageVelocityLoadPM:(ModelItems*)modelItems;

-(double) getAverageTotalSprintDistance:(ModelItems*)modelItems;

-(double) getAverageSitAndReach:(ModelItems*)modelItems;

-(double) getAverageHipRotationL:(ModelItems*)modelItems;

-(double) getAverageHipRotationR:(ModelItems*)modelItems;

-(double) getAverageGroinSqueezeZero:(ModelItems*)modelItems;

-(double) getAverageGroinSqueeze60:(ModelItems*)modelItems;

-(CGFloat) getAverageLoadedMarch:(ModelItems*)modelItems;

-(CGFloat) getAverageFireAndMove:(ModelItems*)modelItems;

-(CGFloat) getAverageJerryCanWalk:(ModelItems*)modelItems;

-(CGFloat) getAverageBoxLift:(ModelItems*)modelItems;

-(CGFloat) getAveragePushUps:(ModelItems*)modelItems;

-(CGFloat) getAverageSitUps:(ModelItems*)modelItems;

-(CGFloat) getAverageRunFiveKM:(ModelItems*)modelItems;

-(CGFloat) getAverageWalk:(ModelItems*)modelItems;

-(CGFloat) getAverageRunDodgeJump:(ModelItems*)modelItems;

-(CGFloat) getAverageEnduranceMarch:(ModelItems*)modelItems;

-(CGFloat) getAverageSwimTest:(ModelItems*)modelItems;

-(CGFloat) getAverageTreadWater:(ModelItems*)modelItems;

- (NSMutableAttributedString*) getAttributedString:(NSString*) string;

- (NSMutableAttributedString*) getAttributedString:(NSString*) string mainTextFontSize:(NSInteger) fontsize subTextFontSize: (NSInteger) secondFontSize;

-(void) setIcon:(UIImageView*)view withPercentage:(CGFloat)percentageValue withValue:(NSInteger)value;

-(NSInteger) setViewChange:(UIView*)view withPercentage:(CGFloat)percentageValue withCount:(NSInteger)count;

-(NSInteger) setFitnessViewChange:(UIView*)view withPercentage:(CGFloat)percentageValue withCount:(NSInteger)count;

-(NSInteger) setMainViewChange:(UIView*)view withPercentage:(CGFloat)percentageValue withCount:(NSInteger)count;

- (NSInteger) getSecondsFromTimeFormat: (NSString*) timeFormat;

- (NSMutableArray*) getMonthsForGraphCoordinates;

- (NSInteger) getAverageRiskOfInjury;

@end
