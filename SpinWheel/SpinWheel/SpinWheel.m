//
//  SpinWheel.m
//  SpinWheel
//
//  Created by ryan on 13-2-17.
//  Copyright (c) 2013年 ryan. All rights reserved.
//

#import "SpinWheel.h"
#import <QuartzCore/QuartzCore.h>

@implementation SpinWheel

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.borderColor = [UIColor yellowColor].CGColor;
        self.layer.borderWidth = 2;
        
        _contentView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:_contentView];
        
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotatingAction:)];
        [recognizer setMinimumNumberOfTouches:1];
        [recognizer setMaximumNumberOfTouches:1];

        [self addGestureRecognizer:recognizer];
        [recognizer release];
        
    }
    return self;
}

- (void)layoutSubviews {
//    [self drawPieces];
    
    
}


- (void)setDelegate:(id<SpinWheelDelegate>)aDelegate {
    BOOL needConfig = NO;
    needConfig = (self.delegate != aDelegate);
    
    _delegate = aDelegate;
    
    if (needConfig) {
        [self reloadData];
    }
}



- (void)reloadData {
    [self _reloadDataIfNeeded];
}

- (void)_reloadDataIfNeeded {
    if (_isActive) {
        
    }
    [self drawPieces];
}


- (void)drawPieces {
    _piecesCount = [self.delegate numberOfPieceInSpinWheel:self];
    
    CGFloat angleSize = 2 * M_PI / _piecesCount;

    for(int i = 0; i < _piecesCount; i++){
        SWPiece *piece = [self.delegate spinWheel:self pieceForIndex:i];
        piece.layer.anchorPoint = CGPointMake(0, 0.5f);
        piece.layer.position = CGPointMake(_contentView.bounds.size.width/2.0-_contentView.frame.origin.x,
                                        _contentView.bounds.size.height/2.0-_contentView.frame.origin.y);
        piece.transform = CGAffineTransformMakeRotation(angleSize*i);

        [_contentView addSubview:piece];
    }
    
    // center mask
    UIImage *image = [UIImage imageNamed:@"assets/background"];
    _centerMask = [[UIImageView alloc] initWithImage:image];
    _centerMask.center = CGPointMake(CGRectGetWidth(_contentView.bounds) * 0.5, CGRectGetHeight(_contentView.bounds) * 0.5);
    [self addSubview:_centerMask];
}

- (void)rotatingAction:(UIPanGestureRecognizer*)recognizer {
    CGPoint currentPoint = [recognizer locationInView:[_contentView superview]];
    CGPoint translate = [recognizer translationInView:[_contentView superview]];

    CGFloat x = currentPoint.x;
    CGFloat y = currentPoint.y;
    CGFloat x0 = currentPoint.x - translate.x;
    CGFloat y0 = currentPoint.y - translate.y;
    
//    NSLog(@"translate : %@ current : %@",NSStringFromCGPoint(translate),NSStringFromCGPoint(currentPoint));
    
    CGFloat rotateRadian =  atan((y - _contentView.center.y)/(x - _contentView.center.x));
    CGFloat rotateRadian0 =  atan((y0 - _contentView.center.y)/(x0 - _contentView.center.x));
    if(recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateBegan) {
        _contentView.transform = CGAffineTransformRotate(_contentView.transform, rotateRadian - rotateRadian0);
    } else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat radians = atan2f(_contentView.transform.b, _contentView.transform.a);
        CGFloat angleSize = 2 * M_PI / _piecesCount;
        NSInteger index = nearbyint(radians / angleSize);

        [self setFakeIndex:index animated:YES];
        
    }
    
    [recognizer setTranslation:CGPointZero inView:[_contentView superview]];
}

- (void)setFakeIndex:(NSInteger)fakeIndex animated:(BOOL)animated {
    CGFloat angleSize = 2 * M_PI / _piecesCount;

    NSInteger realIndex = fakeIndex % _piecesCount;
    
    if (realIndex < 0) {
        _currentIndex = fabs(realIndex);
    } else {
        _currentIndex = _piecesCount - realIndex;
    }
    
//    NSLog(@"currentIndex: %d, real: %d",_currentIndex,realIndex);

    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            _contentView.transform = CGAffineTransformMakeRotation(angleSize * fakeIndex);
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(spinWheel:didSpinToIndex:)]) {
                [self.delegate spinWheel:self didSpinToIndex:_currentIndex];
            }
        }];
        [UIView animateWithDuration:0.2 animations:^{
            _contentView.transform = CGAffineTransformMakeRotation(angleSize * fakeIndex);
        }];
    } else {
        _contentView.transform = CGAffineTransformMakeRotation(angleSize * fakeIndex);
        if ([self.delegate respondsToSelector:@selector(spinWheel:didSpinToIndex:)]) {
            [self.delegate spinWheel:self didSpinToIndex:_currentIndex];
        }
    }
    
    
}

- (void)dealloc {
    [_contentView release];
    [_centerMask release];
    [super dealloc];

}

@end
