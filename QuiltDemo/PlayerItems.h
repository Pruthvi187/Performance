//
//  PlayerItems.h
//  Waratahs
//
//  Created by Pruthvi on 18/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Player;

@interface PlayerItems : NSObject

@property NSMutableArray * players;

+(PlayerItems*) playerItemsWithArray:(NSMutableArray *) array ofPosition:(NSString*)position forMainPosition:(NSString*)mainPosition;

-(void) setPlayerItemsUsingJSONObject:(NSMutableArray *)resultsArray ofPosition:(NSString*)position forMainPosition:(NSString*)mainPosition;

@end
