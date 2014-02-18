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

-(ModelItems*) getModelItems
{
    
    NSString * jsonString = [self getJSONString:@"PlayerData" ofType:@"json"];
    
    NSMutableArray * playerData =  [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    ModelItems * modelItems = [ModelItems modelItemsWithArray:playerData];
    
    //NSMutableArray * array = modelItems.models;
    
    return modelItems;
    
}

-(PlayerItems*) getPlayerItems:(NSString *) position forMainPosition:(NSString*)mainPosition
{
    NSString * jsonString = [self getJSONString:@"PlayerProfile" ofType:@"json"];
    
    NSMutableArray * playerProfileData =  [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    PlayerItems * playrItems = [PlayerItems playerItemsWithArray:playerProfileData ofPosition:position forMainPosition:(NSString*)mainPosition];
    
    return playrItems;
    
}

-(NSString*) getJSONString:(NSString*)fileName ofType:(NSString*)type
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    return  jsonString;
    
}




@end
