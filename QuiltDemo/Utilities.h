//
//  Utilities.h
//  Waratahs
//
//  Created by Pruthvi on 18/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+(Utilities *) sharedClient;

-(NSString *) getFilePath:(NSString *) fileName ofType:(NSString *)type;

@end
