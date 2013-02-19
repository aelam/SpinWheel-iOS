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
- (void)spinWheel:(SpinWheel *)spinWheel willSpinToIndex:(NSInteger)index;
- (void)spinWheel:(SpinWheel *)spinWheel willUnspinIndex:(NSInteger)index;

@end

@protocol SpinWheelDataSource <NSObject>



@end

@interface SpinWheel : UIView <SpinWheelDelegate,SpinWheelDataSource> {
    struct{
        unsigned int highlightPiece:1;
    }_wheelFlags;
    
    int         _piecesCount;
    BOOL        _isActive;
        
    // TODO
    NSMutableSet *_visiblePieces;
    NSMutableSet *_recycledPieces;
    
}


@property (nonatomic,assign) id <SpinWheelDelegate> delegate;
@property (nonatomic,assign) CGFloat insideRadius;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,readonly) UIImageView  *contentView;
@property (nonatomic,retain) UIView  *contentMask;

@property (nonatomic,retain) UIImage *sectorImage;                 // 扇形背景  决定大小 default `[UIImage imageNamed:@"piece.png"];`
@property(nonatomic) UIViewAutoresizing piecesAutoresizingMask;    // default is 右上


- (id)dequeueReusablePiece;

- (void)reloadData;

- (SWPiece *)pieceForIndex:(NSInteger)index;

@end
