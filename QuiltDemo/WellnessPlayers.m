//
//  WellnessPlayers.m
//  Waratahs
//
//  Created by Pruthvi on 21/02/14.
// 
//

#import "WellnessPlayers.h"
#import "Wellness.h"
#import "Player.h"

@implementation WellnessPlayers

@synthesize wellness;

+(WellnessPlayers*) wellnessItemsWithArray:(NSMutableArray *) array forPlayer:(Player*) player
{
    WellnessPlayers * wellnessPlayers = [[WellnessPlayers alloc] init];
    [wellnessPlayers setWellnessItemsUsingJSONObject:array forPlayer:player];
    return wellnessPlayers;
}

-(void) setWellnessItemsUsingJSONObject:(NSMutableArray *)resultsArray forPlayer:(Player*) player
{
    NSMutableArray * items = [[NSMutableArray alloc] init];
    
    for(id item in resultsArray)
    {
        
        Wellness * wellnes = [[Wellness alloc] init];
        
        [wellnes setValuesForKeysWithDictionary:item];
      
        if([wellnes.Position isEqualToString:player.Position])
        {
            [items addObject: wellnes];
        }
        
    }
    self.wellness = items;
}


@end
