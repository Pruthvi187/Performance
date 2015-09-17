//
//  TabBarView.h
//  Waratahs
//
//  Created by Pruthvi on 20/02/14.
 
//

#import <UIKit/UIKit.h>

@interface TabBarView : UIView

@property(nonatomic) CGPoint startPoint;

@property(nonatomic) CGPoint endPoint;

-(void)setLinesPath:(CGPoint)startPoint toPoint:(CGPoint)endPoint;

@end
