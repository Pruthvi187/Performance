//
//  ModelItems.m
//  GraphApp
//
//  Created by Pruthvi on 12/02/14.
//  Copyright (c) 2014 Pruthvi. All rights reserved.
//

#import "ModelItems.h"
#import "Model.h"

@implementation ModelItems

@synthesize models;

+(ModelItems*) modelItemsWithArray:(NSMutableArray *) array
{
    ModelItems * modelItems = [[ModelItems alloc] init];
    [modelItems setModelItemsUsingJSONObject:array];
    return modelItems;
}

-(void) setModelItemsUsingJSONObject:(NSMutableArray *)resultsArray
{
    NSMutableArray * items = [[NSMutableArray alloc] init];
    int i =1;
    for(id item in resultsArray)
    {
       
        Model * model = [[Model alloc] init];
       
        [model setValuesForKeysWithDictionary:item];
       
            NSLog(@"Count is %d", i);
            [items addObject: model];
            i++;
        
    }
    self.models = items;
}

@end
