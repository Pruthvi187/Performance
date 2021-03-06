//
//  PlayerItems.m
//  Waratahs
//
//  Created by Pruthvi on 18/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "PlayerItems.h"
#import "Player.h"

@implementation PlayerItems

@synthesize players;

+(PlayerItems*) playerItemsWithArray:(NSMutableArray *)array ofPosition:(NSString*)position forMainPosition:(NSString*)mainPosition
{
    PlayerItems * playerItems = [[PlayerItems alloc] init];
    [playerItems setPlayerItemsUsingJSONObject:array ofPosition:position forMainPosition:mainPosition];
    return playerItems;
}

-(void) setPlayerItemsUsingJSONObject:(NSMutableArray *)resultsArray ofPosition:(NSString*)position forMainPosition:(NSString*)mainPosition
{
    NSMutableArray * items = [[NSMutableArray alloc] init];
    for(id item in resultsArray)
    {
        
        Player * player = [[Player alloc] init];

        [player setValuesForKeysWithDictionary:item];
        if(position != nil)
        {
            if([position isEqualToString:player.FilterPosition])
            {
                   [items addObject: player];
            }
        }
        else if(mainPosition !=nil)
        {
            if([mainPosition isEqualToString:@"Forwards"])
            {
                if([player.ID integerValue]  < 8)
                {
                    [items addObject:player];
                }
            }
            else
            {
                if([player.ID integerValue]  >= 8)
                {
                    [items addObject:player];
                }
            }
        }
        else
        {
            [items addObject:player];
        }
        
    }
    self.players = items;
}



@end
