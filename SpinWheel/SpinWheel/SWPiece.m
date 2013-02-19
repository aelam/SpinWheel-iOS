//
//  SWPiece.m
//  SpinWheel
//
//  Created by ryan on 13-2-18.
//  Copyright (c) 2013年 ryan. All rights reserved.
//

#import "SWPiece.h"

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
    if (self = [super initWithImage:image]) {
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 80, 80, 80, 50)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _titleLabel.font = [UIFont boldSystemFontOfSize:50];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
   
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
    self.titleLabel.textColor = highlighted?[UIColor redColor]:[UIColor whiteColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
    self.titleLabel.textColor = selected?[UIColor redColor]:[UIColor whiteColor];
}

- (void)dealloc {
    [_titleLabel release];
    [_identifier release];
    [super dealloc];
}

@end
