//
//  CustomTransitionAnimation.m
//  Waratahs
//
//  Created by Pruthvi on 18/09/2015.
//

#import "CustomTransitionAnimation.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomTransitionAnimation() {
    
    CGRect originFrame;
}

@end

@implementation CustomTransitionAnimation

- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.5f;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrameForVC = toViewController.view.frame;
    UIView * containerView = [transitionContext containerView];
    
    CGRect originalFrame = CGRectZero;
    
    CGFloat xScaleFactor = originalFrame.size.width / finalFrameForVC.size.width;
    CGFloat yScaleFactor = originalFrame.size.height / finalFrameForVC.size.height;
    
    CGAffineTransform scaleTransForm = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor);
    
    toViewController.view.transform = scaleTransForm;
    toViewController.view.center = CGPointMake(CGRectGetMidX(originalFrame), CGRectGetMidY(originalFrame));
    toViewController.view.clipsToBounds = YES;
    
    
   // toViewController.view.frame = finalFrameForVC;
    [containerView addSubview:toViewController.view];
    [containerView bringSubviewToFront:toViewController.view];
    //[containerView sendSubviewToBack:toViewController.view];
   
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:0.0 options:nil animations:^{
        
        toViewController.view.transform = scaleTransForm;
        toViewController.view.center = CGPointMake(CGRectGetMidX(finalFrameForVC), CGRectGetMidY(finalFrameForVC));
    }completion:^(BOOL finished){
        [transitionContext completeTransition:YES];
        
    }];
    
    
}


@end
