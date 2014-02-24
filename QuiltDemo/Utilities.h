//
//  Utilities.h
//  Waratahs
//
//  Created by Pruthvi on 18/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WellnessPlayers;

@interface Utilities : NSObject

+(Utilities *) sharedClient;

-(NSString *) getFilePath:(NSString *) fileName ofType:(NSString *)type;

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

@end
