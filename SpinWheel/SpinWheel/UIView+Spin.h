//
//  UIView+Spin.h
//  Test
//
//  Created by ryan on 13-2-20.
//  Copyright (c) 2013年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (Spin)

- (void)rotate:(CGFloat)radian duration:(CGFloat)duration;
- (void)rotate:(CGFloat)radian duration:(CGFloat)duration comletion:(void (^)(BOOL finished))completion;

@end
