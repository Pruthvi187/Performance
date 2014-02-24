//
//  TabBarView.h
//  Waratahs
//
//  Created by Pruthvi on 20/02/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarView : UIView

@property(nonatomic) CGPoint startPoint;

@property(nonatomic) CGPoint endPoint;

-(void)setLinesPath:(CGPoint)startPoint toPoint:(CGPoint)endPoint;

@end
