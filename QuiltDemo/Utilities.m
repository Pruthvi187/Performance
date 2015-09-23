//
//  Utilities.m
//  Waratahs
//
//  Created by Pruthvi on 18/02/14.
 
//

#import "Utilities.h"
#import "WellnessPlayers.h"
#import "Wellness.h"
#import "ModelItems.h"
#import "Model.h"
#import "PlayerItems.h"
#import "DataModel.h"
#import "Colours.h"
#import "Player.h"

typedef enum {
    FITNESS   = 1,
    RISK      = 2,
    WELLBEING = 3,
} IconValues;

@interface Utilities() {
    NSMutableArray * calendarMonths;
}

@end

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
    
    PlayerItems * playerItems = [dataModel getSoldierItems:nil forMainPosition:nil];

    
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

-(CGFloat) getAverageLoadedMarch:(ModelItems*)modelItems
{
    CGFloat loaded_March = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        loaded_March = loaded_March + [model.Loaded_March floatValue];
        count++;
    }
    
    return loaded_March/count;
}

-(CGFloat) getAverageFireAndMove:(ModelItems*)modelItems
{
    CGFloat fireAndMove = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        fireAndMove = fireAndMove + [model.Fire_And_Move floatValue];
        count++;
    }
    
    return fireAndMove/count;
}

-(CGFloat) getAverageJerryCanWalk:(ModelItems*)modelItems
{
    CGFloat jerryCanWalk = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        jerryCanWalk = jerryCanWalk + [model.Jerry_Can_Walk floatValue];
        count++;
    }
    
    return jerryCanWalk/count;
}

-(CGFloat) getAverageBoxLift:(ModelItems*)modelItems
{
    CGFloat boxLift = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        boxLift = boxLift + [model.Box_Lift floatValue];
        count++;
    }
    
    return boxLift/count;
}

-(CGFloat) getAveragePushUps:(ModelItems*)modelItems
{
    CGFloat pushUps = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        pushUps = pushUps + [model.Push_Ups floatValue];
        count++;
    }
    
    return pushUps/count;
}


-(CGFloat) getAverageSitUps:(ModelItems*)modelItems
{
    CGFloat sitUps = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        sitUps = sitUps + [model.Sit_Ups floatValue];
        count++;
    }
    
    return sitUps/count;
}

-(CGFloat) getAverageRunFiveKM:(ModelItems*)modelItems
{
    CGFloat runFiveKM = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        runFiveKM = runFiveKM + [model.Run floatValue];
        count++;
    }
    
    return runFiveKM/count;
}

-(CGFloat) getAverageWalk:(ModelItems*)modelItems
{
    CGFloat walk = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        walk = walk + [model.Walk floatValue];
        count++;
    }
    
    return walk/count;
}

-(CGFloat) getAverageRunDodgeJump:(ModelItems*)modelItems
{
    CGFloat runDodgeJump = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        runDodgeJump = runDodgeJump + [model.Run_Dodge_Jump floatValue];
        count++;
    }
    
    return runDodgeJump/count;
}

-(CGFloat) getAverageEnduranceMarch:(ModelItems*)modelItems
{
    CGFloat enduranceMarch = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        enduranceMarch = enduranceMarch + [model.Endurance_March floatValue];
        count++;
    }
    
    return enduranceMarch/count;
}

-(CGFloat) getAverageSwimTest:(ModelItems*)modelItems
{
    CGFloat swimTest = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        swimTest = swimTest + [model.Swim_Test floatValue];
        count++;
    }
    
    return swimTest/count;
}

-(CGFloat) getAverageTreadWater:(ModelItems*)modelItems
{
    CGFloat treadWater = 0;
    int count = 0;
    
    for(Model * model in modelItems.models)
    {
        treadWater = treadWater + [model.Tread_Water floatValue];
        count++;
    }
    
    return treadWater/count;
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

-(void) setIcon:(UIImageView*)view withPercentage:(CGFloat)percentageValue withValue:(NSInteger)value
{
    NSString * orangeIcon;
    NSString * redIcon;
    NSString * greenIcon;
    
    switch (value) {
        case FITNESS:
        {
            orangeIcon = @"Medium_Fit_Sml";
            greenIcon = @"Bad_Fit_Sml";
            redIcon = @"Good_Fit_Sml";
            break;
        }
        case RISK:
        {
            orangeIcon = @"Medium_Risk_Sml";
            redIcon = @"High_Risk_Sml";
            greenIcon = @"Low_Risk_Sml";
            break;
        }
        case WELLBEING:
        {
            orangeIcon = @"Meh_Sml";
            greenIcon = @"Sad_Sml";
            redIcon = @"Happy_Sml";
            break;
        }
        default:
            break;
    }
    
    
    if(percentageValue > 30 && percentageValue <= 70)
    {
        [view setImage:[UIImage imageNamed:orangeIcon]];
        
    }
    else if (percentageValue > 70)
    {
        [view setImage:[UIImage imageNamed:redIcon]];
    }
    else
    {
        [view setImage:[UIImage imageNamed:greenIcon]];
    }
    
}

-(NSInteger) setFitnessViewChange:(UIView*)view withPercentage:(CGFloat)percentageValue withCount:(NSInteger)count {
    
    if(percentageValue < 0.8 && percentageValue >= 0.6)
    {
        [view setBackgroundColor:UIColorFromHex(0xf86600)];
    } else if (percentageValue < 0.6) {
        [view setBackgroundColor:UIColorFromHex(0xdc001a)];
        count++;
    } else if (percentageValue > 1.2 && percentageValue <= 1.6) {
        
        [view setBackgroundColor:UIColorFromHex(0xf86600)];
    } else if (percentageValue > 1.6) {
        
        [view setBackgroundColor:UIColorFromHex(0xdc001a)];
    } else if(percentageValue >= 0.8 && percentageValue <= 1.2) {
        
        [view setBackgroundColor:UIColorFromHex(0x1e8034)];
        count++;
    }
    
    
    return count;
    
}

-(NSInteger) setViewChange:(UIView*)view withPercentage:(CGFloat)percentageValue withCount:(NSInteger)count {
    
    if(percentageValue < 0.8 && percentageValue >= 0.6) {
        [view setBackgroundColor:UIColorFromHex(0xf86600)];
    } else if (percentageValue < 0.6) {
        [view setBackgroundColor:UIColorFromHex(0x1e8034)];
        count++;
    } else if (percentageValue > 1.2 && percentageValue <= 1.6) {
        [view setBackgroundColor:UIColorFromHex(0xf86600)];
    } else if (percentageValue > 1.6) {
        [view setBackgroundColor:UIColorFromHex(0x1e8034)];
        count++;
    } else if(percentageValue >= 0.8 && percentageValue <= 1.2) {
        [view setBackgroundColor:UIColorFromHex(0xdc001a)];
    }
    
    
    return count;
}

-(NSInteger) setMainViewChange:(UIView*)view withPercentage:(CGFloat)percentageValue withCount:(NSInteger)count {

    
    if (percentageValue <= 30) {
        
        [view setBackgroundColor:UIColorFromHex(0x1e8034)];
    } else if (percentageValue > 30 && percentageValue <= 70) {
        
        [view setBackgroundColor:UIColorFromHex(0xf86600)];
    } else {
        
        [view setBackgroundColor:UIColorFromHex(0xdc001a)];
    }
    
    return count;
}

- (NSInteger) getSecondsFromTimeFormat: (NSString*) timeFormat {
    
    NSArray * timePieces = [timeFormat componentsSeparatedByString:@":"];
    
    NSString * seconds =[timePieces objectAtIndex:1];
    NSString * minutes = [timePieces objectAtIndex:0];
    
    NSInteger  actualMinutes = [minutes integerValue] * 60;
    NSInteger  actualSeconds = [seconds integerValue];
    return actualMinutes + actualSeconds;
}

- (NSMutableArray*) getMonthsForGraphCoordinates {
    
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSInteger month = [components month];
    
    calendarMonths = [[NSMutableArray alloc] initWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul",
                      @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    
    NSMutableArray * graphMonths = [NSMutableArray new];
    
    NSInteger index = month - 1;
    while(index >= 0) {
       
        [graphMonths addObject:[calendarMonths objectAtIndex:index]];
         index = index - 2;
    }
         
    if ([graphMonths count] < 6) {
        
        [graphMonths addObject:[calendarMonths objectAtIndex:month + 2]];
    }
    
    return graphMonths;

}

- (NSInteger) getAverageRiskOfInjury {
    
    DataModel *dataModel = [DataModel sharedClient];
    
    PlayerItems * playerItems = nil;
    playerItems = [dataModel getSoldierItems:nil forMainPosition:nil];
    
    NSInteger riskAverage = 0;
    for (Player * player in playerItems.players) {
        NSString * riskRating = player.RiskRating;
        riskAverage = riskAverage + [riskRating integerValue];
    }
    
    return (NSInteger)riskAverage/[playerItems.players count];
}


@end
