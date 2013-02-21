//
//  SpinWheel.m
//  SpinWheel
//
//  Created by ryan on 13-2-17.
//  Copyright (c) 2013年 ryan. All rights reserved.
//

#import "SpinWheel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+ColorOfPoint.h"
#import "UIView+Spin.h"

static NSInteger const kPieceTagOffset = 2000;

@interface SpinWheel () <UIGestureRecognizerDelegate>

@end

@implementation SpinWheel

@synthesize delegate = _delegate;
@synthesize currentIndex = _currentIndex;
@synthesize contentView = _contentView;
@synthesize contentMask = _contentMask;
@synthesize gestureMode = _gestureMode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        
        _contentView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:_contentView];
        
        _contentMask = [[UIImageView alloc] initWithFrame:CGRectZero];
        _contentMask.userInteractionEnabled = YES;
        [self addSubview:_contentMask];
        
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        recognizer.delegate = self;
        [recognizer setMinimumNumberOfTouches:1];
        [recognizer setMaximumNumberOfTouches:1];

        [self addGestureRecognizer:recognizer];
        [recognizer release];
        
//        self.layer.borderColor = [UIColor yellowColor].CGColor;
//        self.layer.borderWidth = 2;
        
        
        _recycledPieces = [[NSMutableSet alloc] initWithCapacity:0];

        _currentIndex = 0;
        
        _gestureMode = SWGestureModeRotate;
        
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
        
    }
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"frame changed!!%@",NSStringFromCGRect(self.frame));
//            NSLog(@"bounds = %@",NSStringFromCGRect(self.bounds));
//            NSLog(@"_contentView.center = %@",NSStringFromCGPoint(_contentView.center));
//            NSLog(@"_contentView.frame = %@",NSStringFromCGRect(_contentView.frame));

            [self reloadData];
//            NSLog(@"_contentView.center = %@",NSStringFromCGPoint(_contentView.center));
//            NSLog(@"_contentView.frame = %@",NSStringFromCGRect(_contentView.frame));
//
        });
        
    }
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    if (self.delegate == nil || self.contentView.image == nil) {
        return;
    }
    
}

- (void)setDelegate:(id<SpinWheelDelegate>)aDelegate {
    BOOL needConfig = NO;
    needConfig = (_delegate != aDelegate);
    
    _delegate = aDelegate;
    
    if (needConfig) {
        [self reloadData];
    }
}

- (void)setCurrentIndex:(NSInteger)index {
    BOOL needConfig = NO;
    needConfig = (_currentIndex!= index);
    
    _currentIndex = index;
    
    if (needConfig && self.superview) {
        [self reloadData];
    }
}

- (void)reloadData {

    if (self.delegate == nil || self.contentView.image == nil) {
        return;
    }
    
    [self _reloadDataIfNeeded];
}

- (void)_reloadDataIfNeeded {

    [self drawPieces];
}

- (void)recyleAllPieces {
    for(SWPiece *piece in _contentView.subviews) {
        if ([piece isKindOfClass:[SWPiece class]]) {
            [_recycledPieces addObject:piece];
            [piece removeFromSuperview];
        }
    }
    
}

- (void)drawPieces {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    [self recyleAllPieces];
    
    _contentView.transform = CGAffineTransformIdentity;
    CGFloat diameter = MAX(self.contentView.image.size.width,CGRectGetWidth(self.bounds));
    
    _contentView.center = CGPointMake( self.bounds.size.width - diameter * 0.5 + 10,self.bounds.size.height * 0.5);
    
    CGPoint center = _contentMask.center;
    center.y = self.bounds.size.height * 0.5;
    _contentMask.center = center;
    
    _piecesCount = [self.delegate numberOfPieceInSpinWheel:self];
    
    CGFloat angleSize = 2 * M_PI / _piecesCount;

    for(int i = 0; i < _piecesCount; i++){
        SWPiece *piece = [self.delegate spinWheel:self pieceForIndex:i];
        
        piece.tag = kPieceTagOffset + i;
        float height = diameter * sin(angleSize * 0.5);
        piece.frame = CGRectMake(0, 0, diameter * 0.5, height);

        piece.layer.anchorPoint = CGPointMake(0, 0.5f);
        piece.layer.position = CGPointMake(MIN(_contentView.frame.size.width * 0.5 ,_contentView.frame.size.width - diameter * 0.5),
                                           _contentView.bounds.size.height/2);
        piece.transform = CGAffineTransformMakeRotation(angleSize*i);

        [piece setNeedsDisplay];
        [_contentView addSubview:piece];
        
        // Selected the default one 
        [piece setSelected:!!(_currentIndex == i) animated:YES];
        
    }
}


- (void)panGestureAction:(UIPanGestureRecognizer*)recognizer {
    
//    if (self.transform.tx == 0) {
    if (self.gestureMode == SWGestureModeRotate) {
        [self rotateGestureAction:(UIPanGestureRecognizer*)recognizer];
    } else {
        [self dragGestureAction:(UIPanGestureRecognizer*)recognizer];
    }
    
    [recognizer setTranslation:CGPointZero inView:[_contentView superview]];

}

- (void)dragGestureAction:(UIPanGestureRecognizer*)recognizer {

    if ([self.delegate respondsToSelector:@selector(spinWheel:movementOnTranslateMode:)]) {
        [self.delegate spinWheel:self movementOnTranslateMode:recognizer];
    }
    
}

- (void)rotateGestureAction:(UIPanGestureRecognizer*)recognizer {
    
    CGPoint currentPoint = [recognizer locationInView:[_contentView superview]];
    CGPoint translate = [recognizer translationInView:[_contentView superview]];
    CGPoint velocity = [recognizer velocityInView:[_contentView superview]];

    CGFloat x = currentPoint.x;
    CGFloat y = currentPoint.y;
    CGFloat x0 = currentPoint.x - translate.x;
    CGFloat y0 = currentPoint.y - translate.y;
    
    
    CGFloat rotateRadian =  atan((y - _contentView.center.y)/(x - _contentView.center.x));  // new radians
    CGFloat rotateRadian0 =  atan((y0 - _contentView.center.y)/(x0 - _contentView.center.x)); // old radians
    CGFloat radians = atan2f(_contentView.transform.b, _contentView.transform.a);
    
    CGFloat angleSize = 2 * M_PI / _piecesCount;
    NSInteger index = nearbyint(radians / angleSize);

    // cancel old Selected Item
    // Highlight the new one
    NSInteger oldLogicalIndex = [self logicalIndexWithCycleIndex:index];
    SWPiece *oldPiece = [self pieceForIndex:oldLogicalIndex];
    [oldPiece setSelected:NO animated:YES];

    
    
    if(recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateBegan) {
        
        
        _contentView.transform = CGAffineTransformRotate(_contentView.transform, rotateRadian - rotateRadian0);
        
        CGFloat radians = atan2f(_contentView.transform.b, _contentView.transform.a);
        
        NSInteger newIndex = nearbyint(radians / angleSize);
        NSInteger newLogicalIndex = [self logicalIndexWithCycleIndex:newIndex];
        SWPiece *newPiece = [self pieceForIndex:newLogicalIndex];
        
        [newPiece setSelected:YES animated:YES];
        
        
    } else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded) {
        
        
//        _contentView.transform = CGAffineTransformRotate(_contentView.transform, rotateRadian - rotateRadian0);

        if (1) {
//        if (fabsf(velocity.y) > 500) {

            CGFloat offset =  velocity.y /fabsf(velocity.y) * fabsf(velocity.y) / 1000;
            //        radians += offset * M_PI / 2;
            CGFloat offset_radian = offset * angleSize;
            
            
            NSLog(@"radians:%f translate: %@ : velocity : %@ index : %d",radians, NSStringFromCGPoint(translate), NSStringFromCGPoint(velocity),index);
            
            [_contentView rotate:offset_radian duration:0.6 comletion:^(BOOL finished) {
                CGFloat radians = atan2f(_contentView.transform.b, _contentView.transform.a);
                NSInteger index = nearbyint(radians / angleSize);
                [self setFakeIndex:index  animated:YES];
                                
                NSInteger newIndex = nearbyint(radians / angleSize);
                NSInteger newLogicalIndex = [self logicalIndexWithCycleIndex:newIndex];
                SWPiece *newPiece = [self pieceForIndex:newLogicalIndex];
                
                [newPiece setSelected:YES animated:YES];
                
                
            }];
        } else {
            CGFloat radians = atan2f(_contentView.transform.b, _contentView.transform.a);
            NSInteger index = nearbyint(radians / angleSize);
            [self setFakeIndex:index  animated:YES];
            
            NSInteger newIndex = nearbyint(radians / angleSize);
            NSInteger newLogicalIndex = [self logicalIndexWithCycleIndex:newIndex];
            SWPiece *newPiece = [self pieceForIndex:newLogicalIndex];
            
            [newPiece setSelected:YES animated:YES];

        }        
    }
}


// cycleIndex: -`_piecesCount`/2 --> 0 --> `_piecesCount`/2
// loginIndex  0 --> `_piecesCount`
- (NSInteger)logicalIndexWithCycleIndex:(NSInteger)cycleIndex {
    
    NSInteger realIndex = cycleIndex % _piecesCount;
    
    if (realIndex < 0) {
        realIndex = fabs(realIndex);
    } else {
        realIndex = _piecesCount - realIndex;
    }
    
    if (realIndex == _piecesCount) {
        realIndex = 0;
    }
    return realIndex;
}

- (void)setFakeIndex:(NSInteger)fakeIndex animated:(BOOL)animated {
    CGFloat angleSize = 2 * M_PI / _piecesCount;

    // update currentIndex
    _currentIndex = [self logicalIndexWithCycleIndex:fakeIndex];
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            _contentView.transform = CGAffineTransformMakeRotation(angleSize * fakeIndex);
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(spinWheel:didSpinToIndex:)]) {
                [self.delegate spinWheel:self didSpinToIndex:_currentIndex];
            }
        }];
        [UIView animateWithDuration:0.3 animations:^{
            _contentView.transform = CGAffineTransformMakeRotation(angleSize * fakeIndex);
        }];
    } else {
        _contentView.transform = CGAffineTransformMakeRotation(angleSize * fakeIndex);
        if ([self.delegate respondsToSelector:@selector(spinWheel:didSpinToIndex:)]) {
            [self.delegate spinWheel:self didSpinToIndex:_currentIndex];
        }
    }
}

- (id)dequeueReusablePiece {
    if ([_recycledPieces count] > 0) {
        SWPiece *piece = [_recycledPieces anyObject];
        [_recycledPieces removeObject:piece];
        piece.transform = CGAffineTransformIdentity;
        return piece;
    }

    return nil;
}

- (SWPiece *)pieceForIndex:(NSInteger)index {
    NSInteger tag = index + kPieceTagOffset;
    for(SWPiece *piece in _contentView.subviews) {
        if ([piece isKindOfClass:[SWPiece class]] && piece.tag == tag) {
            return piece;
        }
    }
    return nil;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)recognizer {
    CGPoint currentPoint = [recognizer locationInView:[_contentView superview]];

    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (CGRectContainsPoint(self.contentMask.frame, currentPoint)) {
            CGPoint relativePoint = [self.contentMask convertPoint:currentPoint fromView:[_contentView superview]];
            CGFloat alpha = [self.contentMask alphaOfPoint:relativePoint];
            NSLog(@"state : %d",recognizer.state);
            if (alpha == 1) {
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)stackOn {
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeTranslation(-260, 0);
    }];
}

- (void)randomRotateDemo {

    [UIView animateWithDuration:1 delay:0.1 options:UIViewAnimationOptionAutoreverse animations:^{
        self.contentView.transform = CGAffineTransformMakeRotation(-M_PI);
    } completion:^(BOOL finished) {
        self.contentView.transform = CGAffineTransformIdentity;
    }];
    

}



- (void)dealloc {
    [self removeObserver:self forKeyPath:@"frame"];

    [_recycledPieces release];
    [_contentView release];
    [_contentMask release];
    [super dealloc];

}

@end
