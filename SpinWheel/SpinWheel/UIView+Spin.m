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
    if (duration > 0) {
//        [UIView animateWithDuration:0.4 animations:^{
//            self.transform = CGAffineTransformRotate(self.transform, radian);
//        } completion:^(BOOL finished) {
//            
//        }];

//        + (void)transitionWithView:(UIView *)view duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(4_0);

        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.transform = CGAffineTransformRotate(self.transform, radian);
        } completion:^(BOOL finished) {
            completion(YES);

        }];
//        [CATransaction begin];
//        CABasicAnimation *rotationAnimation;
//        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//        rotationAnimation.byValue = [NSNumber numberWithFloat:radian];
//        rotationAnimation.duration = duration;
//        rotationAnimation.removedOnCompletion = NO;
////        rotationAnimation.speed = 1.0f;
////        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//
//        [CATransaction setCompletionBlock:^{
////            [UIView animateWithDuration:0.3 animations:^{
//                self.transform = CGAffineTransformRotate(self.transform, radian);
////            } completion:^(BOOL finished) {
//            
////            }];
//            completion(YES);
//            
//        }];
//        
//        [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//        [CATransaction commit];
    } else {
        self.transform = CGAffineTransformRotate(self.transform, radian);
    }
    
}


@end
