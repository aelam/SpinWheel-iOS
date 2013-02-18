//
//  SWPiece.m
//  SpinWheel
//
//  Created by ryan on 13-2-18.
//  Copyright (c) 2013年 ryan. All rights reserved.
//

#import "SWPiece.h"

@implementation SWPiece

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        
//    }
//    
//    return self;
//}
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
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
