//
//  UIView+drawLines.m
//  Waratahs
//
//  Created by Pruthvi on 20/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "UIView+drawLines.h"

@implementation UIView (drawLines)

-(void) drawlines:(CGPoint)startPoint toPoint:(CGPoint)endPoint withColor:(UIColor*) color
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, NO);
    
    UIBezierPath * path = [[UIBezierPath alloc] init];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [path closePath];
    path.lineWidth = 2.0f;
    [color setFill];
    [path fill];
    //[self setNeedsDisplay];
}

@end
