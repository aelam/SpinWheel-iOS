//
//  UIView+Spin.m
//  Test
//
//  Created by ryan on 13-2-20.
//  Copyright (c) 2013年 ryan. All rights reserved.
//

#import "UIView+Spin.h"

@implementation UIView (Spin)

- (void)rotate:(CGFloat)radian duration:(CGFloat)duration {
    if (duration > 0) {
        [CATransaction begin];
        CABasicAnimation *rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.byValue = [NSNumber numberWithFloat:radian];
        rotationAnimation.duration = duration;
        rotationAnimation.removedOnCompletion = YES;
        
        [CATransaction setCompletionBlock:^{
            self.transform = CGAffineTransformRotate(self.transform, radian);
        }];
        
        [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        [CATransaction commit];
    } else {
        self.transform = CGAffineTransformRotate(self.transform, radian);
    }
    
}

- (void)rotate:(CGFloat)radian duration:(CGFloat)duration comletion:(void (^)(BOOL finished))completion{
    
#if 1
    
    [CATransaction begin];
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.byValue = [NSNumber numberWithFloat:radian];
    rotationAnimation.duration = duration;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.cumulative = YES;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [CATransaction setCompletionBlock:^{
        [self.layer removeAllAnimations];
        self.transform = CGAffineTransformRotate(self.transform, radian);
        completion(YES);

    }];
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [CATransaction commit];

    
#else
    
    if (duration > 0) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.transform = CGAffineTransformRotate(self.transform, radian);
        } completion:^(BOOL finished) {
            completion(YES);

        }];
    } else {
        self.transform = CGAffineTransformRotate(self.transform, radian);
    }
#endif

}

@end
