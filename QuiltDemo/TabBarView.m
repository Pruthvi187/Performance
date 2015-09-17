//
//  TabBarView.m
//  Waratahs
//
//  Created by Pruthvi on 20/02/14.
 
//

#import "TabBarView.h"

@implementation TabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if(self.startPoint.y == 0.0f)
    {
        self.startPoint = CGPointMake(0.0f, 76.0f);
    }
    
    if(self.endPoint.y == 0.0f)
    {
        self.endPoint = CGPointMake(self.frame.size.width, 76.0f);
    }
    
    [self drawlines:self.startPoint toPoint:self.endPoint withColor:[UIColor whiteColor]];
    
}

-(void) drawlines:(CGPoint)startPoint toPoint:(CGPoint)endPoint withColor:(UIColor*) color
{
   
    UIBezierPath * path = [[UIBezierPath alloc] init];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [path closePath];
    path.lineWidth = 0.5f;
    [color setStroke];
    [path stroke];
    [self setNeedsDisplay];
}

-(void)setLinesPath:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.startPoint = startPoint;
    self.endPoint =endPoint;
    [self setNeedsDisplay];
}


@end
