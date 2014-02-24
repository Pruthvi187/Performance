//
//  ModelItems.h
//  GraphApp
//
//  Created by Pruthvi on 12/02/14.
//  Copyright (c) 2014 Pruthvi. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Player;

@interface ModelItems : NSObject

@property NSMutableArray * models;

+(ModelItems*) modelItemsWithArray:(NSMutableArray *) array forPlayer:(Player*) player;

-(void) setModelItemsUsingJSONObject:(NSMutableArray *)resultsArray forPlayer:(Player*) player;

@end
