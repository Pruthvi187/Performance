//
//  WellnessPlayers.h
//  Waratahs
//
//  Created by Pruthvi on 21/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Wellness, Player;

@interface WellnessPlayers : NSObject

@property NSMutableArray * wellness;

+(WellnessPlayers*) wellnessItemsWithArray:(NSMutableArray *) array forPlayer:(Player*) player;

-(void) setWellnessItemsUsingJSONObject:(NSMutableArray *)resultsArray forPlayer:(Player*) player;

@end
