//
//  ModelItems.m
//  GraphApp
//
//  Created by Pruthvi on 12/02/14.
//  Copyright (c) 2014 Pruthvi. All rights reserved.
//

#import "ModelItems.h"
#import "Model.h"
#import "Player.h"

@implementation ModelItems

@synthesize models;

+(ModelItems*) modelItemsWithArray:(NSMutableArray *) array forPlayer:(Player*) player
{
    ModelItems * modelItems = [[ModelItems alloc] init];
    [modelItems setModelItemsUsingJSONObject:array forPlayer:player];
    return modelItems;
}

-(void) setModelItemsUsingJSONObject:(NSMutableArray *)resultsArray forPlayer:(Player*) player
{
    NSMutableArray * items = [[NSMutableArray alloc] init];
    int i =1;
    for(id item in resultsArray)
    {
       
        Model * model = [[Model alloc] init];
       
        [model setValuesForKeysWithDictionary:item];
       
            if([model.ID intValue] == [player.ID intValue])
            {
                   NSLog(@"Count is %d", i);
                   [items addObject: model];
                   i++;
            }
        
    }
    self.models = items;
}

@end
