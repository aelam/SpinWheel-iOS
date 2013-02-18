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

@end

@protocol SpinWheelDataSource <NSObject>



@end

@interface SpinWheel : UIView <SpinWheelDelegate,SpinWheelDataSource> {
    struct{
        unsigned int highlightPiece:1;
    }_wheelFlags;
    
    int         _piecesCount;
    BOOL        _isActive;
    
    UIView      *_contentView;
    UIView      *_centerMask;
    
}


@property (nonatomic,assign) id <SpinWheelDelegate> delegate;
@property (nonatomic,assign) CGFloat insideRadius;
@property (nonatomic,assign) NSInteger currentIndex;
//@property (nonatomic,assign) NSInteger startIndex; //default 0
//@property (nonatomic,assign) 


- (void)reloadData;

- (SWPiece *)pieceForIndex:(NSInteger)index;

@end
