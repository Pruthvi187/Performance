//
//  CustomDismissController.m
//  Waratahs
//
//  Created by Pruthvi on 17/09/2015.
//

#import "CustomDismissController.h"

@implementation CustomDismissController

- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0f;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrameForVC = [transitionContext finalFrameForViewController:toViewController];
    UIView * containerView = [transitionContext containerView];
    
    toViewController.view.frame = finalFrameForVC;
    
    toViewController.view.alpha = 0.5f;
    [containerView addSubview:toViewController.view];
    [containerView sendSubviewToBack:toViewController.view];
    
    
    UIView * snapShotView = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
    snapShotView.frame = fromViewController.view.frame;
    [containerView addSubview:snapShotView];
    
    [fromViewController.view removeFromSuperview];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapShotView.frame = CGRectInset(fromViewController.view.frame, fromViewController.view.frame.size.width/2, fromViewController.view.frame.size.height/2
                                         );
        toViewController.view.alpha = 1.0;
        
    }completion:^(BOOL finished){
        toViewController.view.alpha = 1.0;
        [transitionContext completeTransition:YES];
    }];
}

@end
