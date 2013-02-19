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

static NSInteger const kPieceTagOffset = 2000;

@implementation SpinWheel

@synthesize delegate = _delegate;
@synthesize sectorImage = _sectorImage;
@synthesize currentIndex = _currentIndex;
@synthesize contentView = _contentView;
@synthesize contentMask = _contentMask;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.sectorImage = [UIImage imageNamed:@"piece.png"];

        CGFloat diameter = MAX(self.sectorImage.size.width * 2,CGRectGetWidth(self.bounds));
      
        _contentView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width - diameter + 10,self.frame.size.height * 0.5 - diameter * 0.5, diameter, diameter)];
        _contentView.image = [UIImage imageNamed:@"big-round"];
        [self addSubview:_contentView];
        
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotatingAction:)];
        recognizer.delegate = self;
        [recognizer setMinimumNumberOfTouches:1];
        [recognizer setMaximumNumberOfTouches:1];

        [self addGestureRecognizer:recognizer];
        [recognizer release];
        
        // default sectorImage
        
        _recycledPieces = [[NSMutableSet alloc] initWithCapacity:0];
        
        
        _currentIndex = 0;
        
        
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
    
    if (self.delegate == nil || self.sectorImage == nil) {
        return;
    }
    
}

- (void)setContentMask:(UIView *)mask {
    if (mask != _contentMask) {
        [_contentMask removeFromSuperview];
        [_contentMask release];
        _contentMask = [mask retain];
        
        [self addSubview:_contentMask];
        [self bringSubviewToFront:_contentMask];
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

- (void)setSectorImage:(UIImage *)sectorImage {
    BOOL needConfig = NO;
    needConfig = (_sectorImage != sectorImage);
    
    _sectorImage = sectorImage;
    
    if (needConfig && self.superview) {
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



-(void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.delegate == nil || self.sectorImage == nil) {
        return;
    }

    [self reloadData];
}

- (void)reloadData {

    if (self.delegate == nil || self.sectorImage == nil) {
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
    
    CGFloat diameter = MAX(self.sectorImage.size.width * 2,CGRectGetWidth(self.bounds));
    _contentView.frame = CGRectMake(self.bounds.size.width - diameter + 10,self.frame.size.height * 0.5 - diameter * 0.5 - 18, diameter, diameter);
    
    
    CGPoint center = _contentMask.center;
    center.y = _contentView.center.y;
    _contentMask.center = center;

    _piecesCount = [self.delegate numberOfPieceInSpinWheel:self];
    
    CGFloat angleSize = 2 * M_PI / _piecesCount;

    for(int i = 0; i < _piecesCount; i++){
        SWPiece *piece = [self.delegate spinWheel:self pieceForIndex:i];
        
        piece.tag = kPieceTagOffset + i;
        
        piece.frame = CGRectMake(0, 0, self.sectorImage.size.width, self.sectorImage.size.height);
        NSAssert(self.sectorImage, @"You must set sector Image ");
        piece.layer.anchorPoint = CGPointMake(0, 0.5f);
        piece.layer.position = CGPointMake(MIN(_contentView.frame.size.width * 0.5 ,_contentView.frame.size.width - self.sectorImage.size.width),
                                           _contentView.bounds.size.height/2);
        piece.transform = CGAffineTransformMakeRotation(angleSize*i);

        [piece setNeedsDisplay];
        [_contentView addSubview:piece];
        
        // Selected the default one 
        [piece setSelected:!!(_currentIndex == i) animated:YES];
        
    }
}


- (void)rotatingAction:(UIPanGestureRecognizer*)recognizer {
    CGPoint currentPoint = [recognizer locationInView:[_contentView superview]];
    CGPoint translate = [recognizer translationInView:[_contentView superview]];
    
    CGFloat x = currentPoint.x;
    CGFloat y = currentPoint.y;
    CGFloat x0 = currentPoint.x - translate.x;
    CGFloat y0 = currentPoint.y - translate.y;
    
//    NSLog(@"translate : %@ current : %@",NSStringFromCGPoint(translate),NSStringFromCGPoint(currentPoint));
    
    CGFloat rotateRadian =  atan((y - _contentView.center.y)/(x - _contentView.center.x));  // new radians
    CGFloat rotateRadian0 =  atan((y0 - _contentView.center.y)/(x0 - _contentView.center.x)); // old radians
    CGFloat radians = atan2f(_contentView.transform.b, _contentView.transform.a); 
    
    CGFloat angleSize = 2 * M_PI / _piecesCount;
    NSInteger index = nearbyint(radians / angleSize);


    
    if(recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateBegan) {
        // cancel old Selected Item
        // Highlight the new one 
        NSInteger oldLogicalIndex = [self logicalIndexWithCycleIndex:index];
        SWPiece *oldPiece = [self pieceForIndex:oldLogicalIndex];
        [oldPiece setSelected:NO animated:YES];
        
        _contentView.transform = CGAffineTransformRotate(_contentView.transform, rotateRadian - rotateRadian0);
       
        CGFloat radians = atan2f(_contentView.transform.b, _contentView.transform.a);

        NSInteger newIndex = nearbyint(radians / angleSize);
        NSInteger newLogicalIndex = [self logicalIndexWithCycleIndex:newIndex];
        SWPiece *newPiece = [self pieceForIndex:newLogicalIndex];

        [newPiece setSelected:YES animated:YES];

        
    } else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded) {

        [self setFakeIndex:index animated:YES];
        
    }
    
    [recognizer setTranslation:CGPointZero inView:[_contentView superview]];
}


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
//    NSLog(@"cycleIndex %d realIndex :%d",cycleIndex,realIndex);
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


- (void)dealloc {
    [self removeObserver:self forKeyPath:@"frame"];
    [_recycledPieces release];
    [_contentView release];
    [_contentMask release];
    [super dealloc];

}

@end
