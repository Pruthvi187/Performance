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
#import "ModelItems.h"
#import "Model.h"
#import "PlayerItems.h"
#import "DataModel.h"

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

-(PlayerItems*) getSortedPlayerItems:(NSString*) sortType withSortKind:(BOOL)ascending
                         withPlayers:(NSMutableArray*)players
{
    NSSortDescriptor * sortDescriptior = [[NSSortDescriptor alloc] initWithKey:sortType
                                                                     ascending:ascending];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptior, nil];
    

    
    DataModel * dataModel = [DataModel sharedClient];
    
    PlayerItems * playerItems = [dataModel getPlayerItems:nil forMainPosition:nil];

    
    NSArray *unsortedArray = [NSArray arrayWithArray:players];
    NSArray *sortedArray = [unsortedArray sortedArrayUsingDescriptors:sortDescriptors];
    
    playerItems.players = [[NSMutableArray alloc] initWithArray:sortedArray];
    
    return playerItems;
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


-(double) getAverageSumofVolume:(ModelItems*)modelItems
{
    double sumofVols = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        sumofVols = sumofVols + [model.Sum_ofV2 floatValue];
        count++;
    }
    
    return sumofVols/count;
}

-(double) getAverageAcceleration:(ModelItems*)modelItems
{
    double sumofAcc = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        sumofAcc = sumofAcc + [model.Sumof_AccTotal floatValue];
        count++;
    }
    
    return sumofAcc/count;
}

-(double) getAverageTotalDistance:(ModelItems*)modelItems
{
    double sumofTotalDist = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        sumofTotalDist = sumofTotalDist + [model.SumofVol floatValue];
        count++;
    }
    
    return sumofTotalDist/count;
}

-(double) getAverageForceLoadPM:(ModelItems*)modelItems
{
    double forceLoadPM = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        forceLoadPM = forceLoadPM + [model.AverageoffLmin floatValue];
        count++;
    }
    
    return forceLoadPM/count;
}

-(double) getAveragePercievedExertionRate:(WellnessPlayers*)wellnessItems
{
    double percievedExertionRate = 0;
    int count = 0;
    
    for(Wellness * wellnes in wellnessItems.wellness)
    {
        percievedExertionRate = percievedExertionRate + [wellnes.Perceived_Performance floatValue];
        count++;
    }
    
    return percievedExertionRate/count;
}

-(double) getAverageVelocityChangeLoad:(ModelItems*)modelItems
{
    double avgVelChangeLoad = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        avgVelChangeLoad = avgVelChangeLoad + [model.SumofVCLoadTotal floatValue];
        count++;
    }
    
    return avgVelChangeLoad/count;
}

-(double) getAverageVelocityLoadPM:(ModelItems*)modelItems
{
    double avgVelLoadPM = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        avgVelLoadPM = avgVelLoadPM + [model.AverageofvLmin floatValue];
        count++;
    }
    
    return avgVelLoadPM/count;
}

-(double) getAverageTotalSprintDistance:(ModelItems*)modelItems
{
    double totalSprintDist = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        totalSprintDist = totalSprintDist + [model.SumofSpr floatValue];
        count++;
    }
    
    return totalSprintDist/count;
}

-(double) getAverageSitAndReach:(ModelItems*)modelItems
{
    double totalSitReach = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        totalSitReach = totalSitReach + [model.SitReach floatValue];
        count++;
    }
    
    return totalSitReach/count;
}

-(double) getAverageHipRotationL:(ModelItems*)modelItems
{
    double hipRotationL = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        hipRotationL = hipRotationL + [model.HipRotation_L floatValue];
        count++;
    }
    
    return hipRotationL/count;
}

-(double) getAverageHipRotationR:(ModelItems*)modelItems
{
    double hipRotationR = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        hipRotationR = hipRotationR + [model.HipRotation_R floatValue];
        count++;
    }
    
    return hipRotationR/count;
}

-(double) getAverageGroinSqueezeZero:(ModelItems*)modelItems
{
    double groinSqueezeZero = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        groinSqueezeZero = groinSqueezeZero + [model.GroinSqueeze_0 floatValue];
        count++;
    }
    
    return groinSqueezeZero/count;
}

-(double) getAverageGroinSqueeze60:(ModelItems*)modelItems
{
    double groinSqueeze60 = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        groinSqueeze60 = groinSqueeze60 + [model.GroinSqueeze_60 floatValue];
        count++;
    }
    
    return groinSqueeze60/count;
}

- (NSMutableAttributedString*) getAttributedString:(NSString*) string  {
    
    return [self getAttributedString:string mainTextFontSize:14 subTextFontSize:10];

}

- (NSMutableAttributedString*) getAttributedString:(NSString*) string mainTextFontSize:(NSInteger) fontsize subTextFontSize: (NSInteger) secondFontSize {
    
    NSInteger rangeLength = [string length];
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:fontsize] range:NSMakeRange(0, rangeLength - 1)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:secondFontSize] range:NSMakeRange(rangeLength - 1, 1)];
    return attributedString;
    
}


@end
