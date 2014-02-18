//
//  Utilities.m
//  Waratahs
//
//  Created by Pruthvi on 18/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (Utilities *) sharedClient
{
    static Utilities * utilities;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        utilities = [[Utilities alloc] init];
    });
    
    return  utilities;
}

-(NSString *) getFilePath:(NSString *) fileName ofType:(NSString *)type
{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    return filePath;
}

@end
