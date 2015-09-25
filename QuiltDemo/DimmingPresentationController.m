//
//  DimmingPresentationController.m
//  Waratahs
//  Created by Pruthvi on 17/09/2015.
//

#import "DimmingPresentationController.h"
#import "Colours.h"

@interface DimmingPresentationController()

@property (nonatomic, readonly) UIView * dimmingView;

@end

@implementation DimmingPresentationController

- (UIView*) dimmingView {
    static UIView *instance = nil;
    if (instance == nil) {
        instance = [[UIView alloc] initWithFrame:self.containerView.bounds];
        instance.backgroundColor = UIColorFromHexWithAlpha(0xf2e6d5, 0.30);
    }
    return instance;
}

- (void) presentationTransitionWillBegin {
    
    self.dimmingView.frame = self.containerView.bounds;
    self.dimmingView.alpha = 0;
    [self.containerView addSubview:self.dimmingView];
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
        self.dimmingView.alpha = 1;
        
    }completion:nil];
}

- (void) presentationTransitionDidEnd:(BOOL)completed {
    if(!completed) {
        [self.dimmingView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin {
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0;
    } completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.presentingViewController.view setAlpha:1.0];

        [self.dimmingView removeFromSuperview];
    }
}

@end
