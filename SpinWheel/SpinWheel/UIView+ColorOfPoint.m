//
//  UIView+ColorOfPoint.m
//  SpinWheel
//
//  Created by ryan on 13-2-19.
//  Copyright (c) 2013年 ryan. All rights reserved.
//

#import "UIView+ColorOfPoint.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (ColorOfPoint)

- (CGFloat)alphaOfPoint:(CGPoint)point {
    unsigned char pixel[4] = {0};
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
	CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast);
    
	CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
    
	//NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    
	return pixel[3]/255.0;
}

- (UIColor *) colorOfPoint:(CGPoint)point
{
	unsigned char pixel[4] = {0};
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
	CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast);
    
	CGContextTranslateCTM(context, -point.x, -point.y);
    
//	[self.layer renderInContext:context];
    
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
    
	//NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    
	UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
	return color;
}

@end
