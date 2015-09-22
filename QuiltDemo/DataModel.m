//
//  DataModel.m
//  GraphApp
//
//  Created by Pruthvi on 12/02/14.
//  Copyright (c) 2014 Pruthvi. All rights reserved.
//

#import "DataModel.h"
#import "PlayerItems.h"
#import "ModelItems.h"
#import "WellnessPlayers.h"

@implementation DataModel

+ (DataModel *) sharedClient
{
    static DataModel * dataModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataModel = [[DataModel alloc] init];
    });
    
    return  dataModel;
}

-(ModelItems*) getModelItems:(Player*) player
{
    
    NSString * jsonString = [self getJSONString:@"SoldierData" ofType:@"json"];
    
    NSMutableArray * playerData =  [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    ModelItems * modelItems = [ModelItems modelItemsWithArray:playerData forPlayer:player];
    
    return modelItems;
    
}

-(PlayerItems*) getPlayerItems:(NSString *) position forMainPosition:(NSString*)mainPosition
{
    NSString * jsonString = [self getJSONString:@"PlayerProfile" ofType:@"json"];
    
    NSMutableArray * playerProfileData =  [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    PlayerItems * playrItems = [PlayerItems playerItemsWithArray:playerProfileData ofPosition:position forMainPosition:(NSString*)mainPosition];
    
    return playrItems;
    
}

-(PlayerItems*) getSoldierItems:(NSString *) position forMainPosition:(NSString*)mainPosition
{
    NSString * jsonString = [self getJSONString:@"SoldierProfile" ofType:@"json"];
    
    NSMutableArray * playerProfileData =  [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    PlayerItems * playrItems = [PlayerItems playerItemsWithArray:playerProfileData ofPosition:position forMainPosition:mainPosition];
    
    return playrItems;
    
}

-(WellnessPlayers*) getPlayersWellness:(Player*) player
{
    NSString * jsonString = [self getJSONString:@"Wellness" ofType:@"json"];
    
    NSMutableArray * wellnessData =  [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    WellnessPlayers * wellnessItems = [WellnessPlayers wellnessItemsWithArray:wellnessData forPlayer:player];
    
    return wellnessItems;
}

-(NSString*) getJSONString:(NSString*)fileName ofType:(NSString*)type
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    return  jsonString;
    
}




@end
