//
//  InnerShadowLabel.m
//  SpinWheel
//
//  Created by Ryan Wang on 13-2-21.
//  Copyright (c) 2013年 ryan. All rights reserved.
//

#import "InnerShadowLabel.h"

@implementation InnerShadowLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIImage*)blackSquareOfSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [[UIColor blackColor] setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size.width, size.height));
    UIImage *blackSquare = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blackSquare;
}


- (CGImageRef)createMaskWithSize:(CGSize)size shape:(void (^)(void))block {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    block();
    CGImageRef shape = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
    UIGraphicsEndImageContext();
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(shape),
                                        CGImageGetHeight(shape),
                                        CGImageGetBitsPerComponent(shape),
                                        CGImageGetBitsPerPixel(shape),
                                        CGImageGetBytesPerRow(shape),
                                        CGImageGetDataProvider(shape), NULL, false);
    return mask;
}


- (void)drawTextInRect:(CGRect)rect {
    
//}


//- (void)drawRect:(CGRect)rect {
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40.0f];
    CGSize fontSize = [self.text sizeWithFont:font];
    
    CGImageRef mask = [self createMaskWithSize:rect.size shape:^{
        [[UIColor blackColor] setFill];
        CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
        [[UIColor whiteColor] setFill];
        // custom shape goes here
        [self.text drawAtPoint:CGPointMake((self.bounds.size.width/2)-(fontSize.width/2), 0) withFont:font];
        [self.text drawAtPoint:CGPointMake((self.bounds.size.width/2)-(fontSize.width/2), -1) withFont:font];
    }];
    
    CGImageRef cutoutRef = CGImageCreateWithMask([self blackSquareOfSize:rect.size].CGImage, mask);
    CGImageRelease(mask);
    UIImage *cutout = [UIImage imageWithCGImage:cutoutRef scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    CGImageRelease(cutoutRef);
    
    CGImageRef shadedMask = [self createMaskWithSize:rect.size shape:^{
        [[UIColor whiteColor] setFill];
        CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
//        CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0, 1), 1.0f, [[UIColor colorWithWhite:0.0 alpha:0.5] CGColor]);
        CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(0.5, 0.5), 0.5, [[UIColor colorWithWhite:0.0 alpha:0.5] CGColor]);
        [cutout drawAtPoint:CGPointZero];
    }];
    
    // create negative image
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [[UIColor blackColor] setFill];
    // custom shape goes here
    [self.text drawAtPoint:CGPointMake((self.bounds.size.width/2)-(fontSize.width/2), -1) withFont:font];
    UIImage *negative = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef innerShadowRef = CGImageCreateWithMask(negative.CGImage, shadedMask);
    CGImageRelease(shadedMask);
    UIImage *innerShadow = [UIImage imageWithCGImage:innerShadowRef scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    CGImageRelease(innerShadowRef);
    
    // draw actual image
    [[UIColor whiteColor] setFill];
    [self.text drawAtPoint:CGPointMake((self.bounds.size.width/2)-(fontSize.width/2), -0.5) withFont:font];
    [[UIColor colorWithWhite:0.76 alpha:1.0] setFill];
    [self.text drawAtPoint:CGPointMake((self.bounds.size.width/2)-(fontSize.width/2), -1) withFont:font];
    
    // finally apply shadow
    [innerShadow drawAtPoint:CGPointZero];
}


@end
