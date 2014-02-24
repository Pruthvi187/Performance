//
//  Utilities.m
//  Waratahs
//
//  Created by Pruthvi on 18/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "Utilities.h"
#import "WellnessPlayers.h"
#import "Wellness.h"

@implementation Utilities

+ (Utilities *) sharedClient
{
    static Utilities * utilities;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        utilities = [[Utilities alloc] init];
    });
    
    return  utilities;
}

-(NSString *) getFilePath:(NSString *) fileName ofType:(NSString *)type
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    return filePath;
}

-(double) getAverageSleepQuality:(WellnessPlayers*)wellness 
{
    double total_sleep = 0;
    int count = 0;
    
    for(Wellness * well in wellness.wellness)
    {
        total_sleep = total_sleep + [well.Sleep_Quality floatValue];
        count++;
    }
    
    return total_sleep/count;
}

-(double) getAverageLegHeaviness:(WellnessPlayers*)wellness
{
    double leg_heaviness = 0;
    int count = 0;
    
    for(Wellness * well in wellness.wellness)
    {
        leg_heaviness = leg_heaviness + [well.Leg_Heaviness floatValue];
        count++;
    }
    
    return leg_heaviness/count;
}

-(double) getAverageBackPain:(WellnessPlayers*)wellness
{
    double back_pain = 0;
    int count = 0;
    
    for(Wellness * well in wellness.wellness)
    {
        back_pain = back_pain + [well.BackPain floatValue];
        count++;
    }
    
    return back_pain/count;
}

-(double) getAverageCalves:(WellnessPlayers*)wellness
{
    double calves = 0;
    int count = 0;
    
    for(Wellness * well in wellness.wellness)
    {
        calves = calves + [well.Calves floatValue];
        count++;
    }
    
    return calves/count;
}

-(double) getAverageRecoveryIndex:(WellnessPlayers*)wellness
{
    double recovery_index = 0;
    int count = 0;
    
    for(Wellness * well in wellness.wellness)
    {
        recovery_index = recovery_index + [well.Recovery_Index floatValue];
        count++;
    }
    
    return recovery_index/count;
}

-(double) getAverageMuscleSoreness:(WellnessPlayers*)wellness
{
    double muscle_soreness = 0;
    int count = 0;
    
    for(Wellness * well in wellness.wellness)
    {
        muscle_soreness = muscle_soreness + [well.Muscle_Soreness floatValue];
        count++;
    }
    
    return muscle_soreness/count;
}

-(double) getAverageTrainingState:(WellnessPlayers*)wellness
{
    double training_state = 0;
    int count = 0;
    
    for(Wellness * well in wellness.wellness)
    {
        training_state = training_state + [well.Traning_State floatValue];
        count++;
    }
    
    return training_state/count;
}

-(double) getAverageROMTightness:(WellnessPlayers*)wellness
{
    double rom_tightness = 0;
    int count = 0;
    
    for(Wellness * well in wellness.wellness)
    {
        rom_tightness = rom_tightness + [well.ROM_Tightness floatValue];
        count++;
    }
    
    return rom_tightness/count;
}

-(double) getAverageHipFlexorQuad:(WellnessPlayers*)wellness
{
    double hipflexor_quad = 0;
    int count = 0;
    
    for(Wellness * well in wellness.wellness)
    {
        hipflexor_quad = hipflexor_quad + [well.HipFlexor_Quads floatValue];
        count++;
    }
    
    return hipflexor_quad/count;
}

-(double) getAverageGroin:(WellnessPlayers*)wellness
{
    double groin = 0;
    int count = 0;
    
    for(Wellness * well in wellness.wellness)
    {
        groin = groin + [well.Groin floatValue];
        count++;
    }
    
    return groin/count;
}

-(double) getAverageHamstrings:(WellnessPlayers*)wellness
{
    double hamstrings = 0;
    int count = 0;
    
    for(Wellness * well in wellness.wellness)
    {
        hamstrings = hamstrings + [well.Hamstring floatValue];
        count++;
    }
    
    return hamstrings/count;
}

@end
