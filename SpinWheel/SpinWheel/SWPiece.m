//
//  SWPiece.m
//  SpinWheel
//
//  Created by ryan on 13-2-18.
//  Copyright (c) 2013年 ryan. All rights reserved.
//

#import "SWPiece.h"
#import "UIView+Glow.h"
#import "RRSGlowLabel.h"

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
    if (self = [super initWithImage:nil]) {
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];

    _titleLabel = [[RRSGlowLabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 80, 80, 80, 50)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _titleLabel.font = [UIFont boldSystemFontOfSize:50];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
//    _titleLabel.highlightedTextColor = [UIColor yellowColor];
    [self addSubview:_titleLabel];

    
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGFloat rgba[] = {1.0,0.0,1.0,1.0};
    CGContextSetFillColor(context, rgba);
    CGContextMoveToPoint(context, 0, CGRectGetHeight(rect) * 0.5);
    CGContextAddArc(context, 0, CGRectGetHeight(rect) * 0.5, CGRectGetWidth(rect),  -15*(M_PI/180), 15*(M_PI/180), 0);
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
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
            self.titleLabel.textColor = highlighted?[UIColor redColor]:[UIColor whiteColor];
//        } completion:^(BOOL finished) {
        
//        }];
    } else {
//        [self.titleLabel stopGlowing];
        self.titleLabel.textColor = highlighted?[UIColor redColor]:[UIColor whiteColor];
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
            self.titleLabel.textColor = selected?[UIColor redColor]:[UIColor whiteColor];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        self.titleLabel.textColor = selected?[UIColor redColor]:[UIColor whiteColor];
    }
}

- (void)dealloc {
    [_titleLabel release];
    [_identifier release];
    [super dealloc];
}

@end
