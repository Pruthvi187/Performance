//
//  DataModel.h
//  GraphApp
//
//  Created by Pruthvi on 12/02/14.
//  Copyright (c) 2014 Pruthvi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelItems, PlayerItems;

@interface DataModel : NSObject

+(DataModel*) sharedClient;

-(ModelItems*) getModelItems;

-(PlayerItems*) getPlayerItems:(NSString *) position forMainPosition:(NSString*)mainPosition;


@end
