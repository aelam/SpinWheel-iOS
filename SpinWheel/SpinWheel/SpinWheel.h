//
//  SpinWheel.h
//  SpinWheel
//
//  Created by ryan on 13-2-17.
//  Copyright (c) 2013年 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWPiece.h"


@class SpinWheel;

@protocol SpinWheelDelegate <NSObject>

- (SWPiece *)spinWheel:(SpinWheel *)spinWheel pieceForIndex:(NSInteger)index;
- (NSInteger)numberOfPieceInSpinWheel:(SpinWheel *)SpinWheel;

@optional
- (void)spinWheel:(SpinWheel *)spinWheel didSpinToIndex:(NSInteger)index;
//- (void)spinWheel:(SpinWheel *)spinWheel willSpinToIndex:(NSInteger)index;
//- (void)spinWheel:(SpinWheel *)spinWheel willUnspinIndex:(NSInteger)index;

- (void)spinWheel:(SpinWheel *)spinWheel movementOnTranslateMode:(UIPanGestureRecognizer *)recognizer;

@end

enum SWGestureMode {
    SWGestureModeTranslate,
    SWGestureModeRotate,
};

@interface SpinWheel : UIView <SpinWheelDelegate> {

    int         _piecesCount;
    BOOL        _isActive;
        
    NSMutableSet *_recycledPieces;
    
    int            _gestureMode;
    
    
    NSInteger      _oldSelectedPieceIndex;
}


@property (nonatomic,assign)  id <SpinWheelDelegate> delegate;

@property (nonatomic,assign)  NSInteger     currentIndex;
@property (nonatomic,readonly)UIImageView   *contentView;
@property (nonatomic,readonly)UIImageView   *contentMask;
@property (nonatomic,assign) int           gestureMode;
@property (nonatomic,assign) CGFloat        radius;

- (id)dequeueReusablePiece;

- (void)reloadData;

- (SWPiece *)pieceForIndex:(NSInteger)index;

- (void)randomRotateDemo;

- (void)waitOnLeft;

@end
