//
//  CustomPresentationController.m
//  Waratahs
//
//  Created by Pruthvi on 17/09/2015.
//

#import "CustomPresentationController.h"

@implementation CustomPresentationController

- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return  2.0f;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController * fromViewControlelr = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrameForVC = [transitionContext finalFrameForViewController:toViewController];
    
    UIView * containerView = [transitionContext containerView];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    toViewController.view.frame = CGRectOffset(finalFrameForVC, 0, -bounds.size.height);
    [containerView addSubview:toViewController.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        fromViewControlelr.view.alpha = 0.5;
        toViewController.view.frame = finalFrameForVC;
    }completion:^(BOOL finished){
        [transitionContext completeTransition:YES];
        //fromViewControlelr.view.alpha = 1.0;
    }];
}

@end
