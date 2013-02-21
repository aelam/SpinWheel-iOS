//
//  SWPiece.m
//  SpinWheel
//
//  Created by ryan on 13-2-18.
//  Copyright (c) 2013年 ryan. All rights reserved.
//

#import "SWPiece.h"
#import "UIView+Glow.h"
#import "FXLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "InnerShadowLabel.h"


@interface SWPiece ()

@property (nonatomic,copy) NSString *identifier;


@end

@implementation SWPiece

@synthesize titleLabel = _titleLabel;
@synthesize identifier = _identifier;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
        
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    if (self = [super initWithFrame:CGRectZero]) {
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];

    _titleLabel = [[FXLabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 100, 80, 80, 80)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _titleLabel.font = [UIFont boldSystemFontOfSize:50];
    _titleLabel.backgroundColor = [UIColor clearColor];
#if 0
    _titleLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    _titleLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.65];
    _titleLabel.shadowOffset = CGSizeMake(0.8, 0.8);
    _titleLabel.innerShadowBlur = 0;
    _titleLabel.innerShadowColor = [UIColor colorWithWhite:0 alpha:0.27];
    _titleLabel.innerShadowOffset = CGSizeMake(0.5, 0.5);
    
    _titleLabel.highlightedTextColor = [UIColor redColor];

#else
    _titleLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    _titleLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.65];
    _titleLabel.shadowOffset = CGSizeMake(0.7,0.7);
    _titleLabel.innerShadowBlur = 0.5;
    _titleLabel.innerShadowColor = [UIColor colorWithWhite:0 alpha:0.27];
    _titleLabel.innerShadowOffset = CGSizeMake(0.5,0.5);
    _titleLabel.highlightedTextColor = [UIColor redColor];
//
//    CGPathRef shadowPath = CGPathCreateWithRect(_titleLabel.bounds, NULL);
//    _titleLabel.layer.shadowPath = shadowPath;
//    CGPathRelease(shadowPath);
#endif
    [self addSubview:_titleLabel];

    
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.76,0.76,0.76,1.0);
    CGFloat rgba[] = {0.76,0.76,0.76,1.0};
    CGContextSetFillColor(context, rgba);
    CGContextMoveToPoint(context, 0, CGRectGetHeight(rect) * 0.5);
    CGContextAddArc(context, 0, CGRectGetHeight(rect) * 0.5, CGRectGetWidth(rect) - 10,  -15*(M_PI/180), 15*(M_PI/180), 0);
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextStrokePath(context);

    [self drawCircleLinesInRect:rect inContext:context];
    
}

- (void)drawCircleLinesInRect:(CGRect)rect inContext:(CGContextRef)context{
    
//    10
//    sin(10 * 180 * M_1_PI);
    
    CGContextSetRGBStrokeColor(context, 0.72, 0.72,0.72, 1.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 0.5);

    CGFloat radius = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);

    
    CGFloat rightOffset = 13;
    
//    CGFloat angle = 10 * M_PI / 180;
    CGFloat angle = 0;
    
    CGFloat lineMaxRadius = radius - rightOffset;
    CGFloat lineMinRadius = radius - 119;
    
    for(float i = 12;i< 15 ;i= i+0.5) {
        angle = i * M_PI / 180;
        
        
        CGFloat x0 = lineMinRadius * cos(angle);
        CGFloat y0 = height * 0.5 + lineMinRadius * sin(angle);//radius * 0.5 * cos(angle) + height * 0.5;
        
        CGFloat x1 =  lineMaxRadius * cos(angle); ;//radius * sin(angle);
        CGFloat y1 =  height * 0.5 + lineMaxRadius* sin(angle);
        
        
        CGFloat x2 = lineMinRadius * cos(-angle);
        CGFloat y2 = height * 0.5 + lineMinRadius * sin(-angle);//radius * 0.5 * cos(angle) + height * 0.5;
        
        CGFloat x3 =  lineMaxRadius * cos(-angle); ;//radius * sin(angle);
        CGFloat y3 =  height * 0.5 + lineMaxRadius* sin(-angle);
    

        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat components[4] = {0.86, 0.86, 0.86, 1.0};
        CGColorRef shadowColor = CGColorCreate(colorSpace, components);
        CGContextSetShadowWithColor(context, CGSizeMake(0.0f,0.5), 0, shadowColor);
        CGContextStrokePath(context);

        
        CGContextMoveToPoint(context, x0, y0);
        CGContextAddLineToPoint(context, x1, y1);

        CGContextMoveToPoint(context, x2, y2);
        CGContextAddLineToPoint(context, x3, y3);

        
        CGContextStrokePath(context);
    }
    
//    CGFloat offset = 10;


}



- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    [super setHighlighted:highlighted animated:animated];
    self.titleLabel.highlighted = highlighted;

    
    if (animated) {
        //        - (void) startGlowingWithColor:(UIColor*)color fromIntensity:(CGFloat)fromIntensity toIntensity:(CGFloat)toIntensity repeat:(BOOL)repeat {

//        [self.titleLabel startGlowingWithColor:[UIColor colorWithWhite:0.5 alpha:.8] fromIntensity:1 toIntensity:1 repeat:NO];
//        self.titleLabel.glowColor = [UIColor colorWithWhite:0.5 alpha:.8];
//        self.titleLabel.glowOffset = CGSizeMake(0.0, 0.0);
//        self.titleLabel.glowAmount = 30.0;

        
//        [UIView animateWithDuration:0.4 animations:^{
//            self.titleLabel.textColor = highlighted?[UIColor redColor]:[UIColor whiteColor];
//        } completion:^(BOOL finished) {
        
//        }];
    } else {
//        [self.titleLabel stopGlowing];
//        self.titleLabel.textColor = highlighted?[UIColor redColor]:[UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.titleLabel.highlighted = selected;
    
    if (selected) {
//        [self.titleLabel startGlowingWithColor:[UIColor colorWithWhite:1 alpha:.8] intensity:1];
//        [self.titleLabel startGlowingWithColor:[UIColor colorWithWhite:0.5 alpha:.8] fromIntensity:1 toIntensity:1 repeat:NO];
//        self.titleLabel.glowColor = [UIColor colorWithRed:0 green:0.70 blue:1.0 alpha:1.0];
//        self.titleLabel.glowOffset = CGSizeMake(0, 0);
//        self.titleLabel.glowAmount = 100;


    } else {
//        [self.titleLabel stopGlowing];
//        self.titleLabel.glowColor = [UIColor colorWithRed:0.20 green:0.70 blue:1.0 alpha:1.0];
//        self.titleLabel.glowOffset = CGSizeMake(0.0, 0.0);
//        self.titleLabel.glowAmount = 0;

    }
    
    if (animated) {

        [UIView animateWithDuration:0.4 animations:^{
//            self.titleLabel.textColor = selected?[UIColor redColor]:[UIColor whiteColor];
        } completion:^(BOOL finished) {
            
        }];
    } else {
//        self.titleLabel.textColor = selected?[UIColor redColor]:[UIColor whiteColor];
    }
}


- (NSString *)description {
    return [NSString stringWithFormat:@"text : %@ tag : %d",self.titleLabel.text,self.tag];
}

- (void)dealloc {
    [_titleLabel release];
    [_identifier release];
    [super dealloc];
}

@end
