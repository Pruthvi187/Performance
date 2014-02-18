//
//  ModelItems.h
//  GraphApp
//
//  Created by Pruthvi on 12/02/14.
//  Copyright (c) 2014 Pruthvi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelItems : NSObject

@property NSMutableArray * models;

+(ModelItems*) modelItemsWithArray:(NSMutableArray *) array;

-(void) setModelItemsUsingJSONObject:(NSMutableArray *)resultsArray;

@end
