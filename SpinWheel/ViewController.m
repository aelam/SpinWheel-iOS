//
//  ViewController.m
//  SpinWheel
//
//  Created by ryan on 13-2-17.
//  Copyright (c) 2013年 ryan. All rights reserved.
//

#import "ViewController.h"
#import "SpinWheel.h"
#import "SWPiece.h"
#import <QuartzCore/QuartzCore.h>
#import "RRSGlowLabel.h"

#import "IITableView.h"


static NSInteger const kCommentTextViewHeight = 217;

@interface ViewController () <SpinWheelDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController {
    UIButton *finishButton;
    SpinWheel *wheel;
    
    UILabel *commentLabel;
    UITextView *commentTextView;
}


- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"filter_foot_bg"]];
    
    wheel = [[SpinWheel alloc]initWithFrame:self.view.bounds];
    wheel.delegate = self;
    [self.view addSubview:wheel];
    
    wheel.contentView.image = [UIImage imageNamed:@"big-round"];
    [wheel.contentView sizeToFit];
    wheel.contentMask.image = [UIImage imageNamed:@"content_mask"];
    [wheel.contentMask sizeToFit];
    [wheel.contentMask setNeedsLayout];
    
    finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(0, 0, 124, 48);
    finishButton.center = CGPointMake(150, CGRectGetHeight(wheel.contentMask.frame) * 0.5);
    [finishButton setImage:[UIImage imageNamed:@"finish_button"] forState:UIControlStateNormal];
    [wheel.contentMask addSubview:finishButton];
    
    [finishButton addTarget:self action:@selector(finishSpinAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    [wheel addObserver:self forKeyPath:@"transform.tx" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [wheel randomRotateDemo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];

}

- (void)spinWheel:(SpinWheel *)spinWheel movementOnTranslateMode:(UIPanGestureRecognizer *)recognizer {

    [commentTextView endEditing:YES];
    
    CGPoint translate = [recognizer translationInView:wheel];
    
    if(recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateBegan) {
        
        wheel.transform = CGAffineTransformTranslate(wheel.transform, translate.x, 0);

        /*
        if(CGRectGetMaxX(wheel.frame) >= CGRectGetMinX(commentTextView.frame)) {
            commentTextView.hidden = YES;
            commentLabel.hidden = YES;
            
        } else {
            commentTextView.hidden = NO;
            commentLabel.hidden = NO;
        }
        */
        
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
        
    } else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded) {

        if(CGRectGetMaxX(wheel.frame) >= CGRectGetMinX(commentTextView.frame)) {
            // 回到原位
            [UIView animateWithDuration:0.2 animations:^{
                wheel.transform = CGAffineTransformIdentity;
                wheel.contentView.transform = CGAffineTransformRotate(wheel.contentView.transform, M_PI / 24);
                commentTextView.hidden = YES;
                commentLabel.hidden = YES;
            } completion:^(BOOL finished) {
                wheel.gestureMode = SWGestureModeRotate;

            }];

        } else {
            [UIView animateWithDuration:0.2 animations:^{
                wheel.transform = CGAffineTransformMakeTranslation(-260, 0);
                commentTextView.hidden = NO;
                commentLabel.hidden = NO;
            } completion:^(BOOL finished) {
                [commentTextView becomeFirstResponder];
                UIBarButtonItem *submitItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitAction:)];
                self.navigationItem.rightBarButtonItem = submitItem;
                [submitItem release];

            }];
        }
    }
}


- (IBAction)finishSpinAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    wheel.gestureMode = SWGestureModeTranslate;
    [UIView animateWithDuration:0.2 animations:^{
        wheel.transform = CGAffineTransformMakeTranslation(-260, 0);
    } completion:^(BOOL finished) {
        [self showCommentStaff];
        
    }];
}



- (void)showCommentStaff {
    
    if (commentLabel == nil) {
        commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 25, 199, 30)];
        commentLabel.text = @"说两句";
        commentLabel.textColor = [UIColor whiteColor];
        commentLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:commentLabel];
        
    }
    commentLabel.hidden = NO;
    
    if (commentTextView == nil) {
        commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(110, 55, 199, kCommentTextViewHeight)];
        commentTextView.layer.cornerRadius = 8;
        commentTextView.textColor = [UIColor whiteColor];
        commentTextView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
        [self.view addSubview:commentTextView];
    }

    commentTextView.hidden = NO;
    [commentTextView becomeFirstResponder];

    [self.view bringSubviewToFront:wheel];

    UIBarButtonItem *submitItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitAction:)];
    [self.navigationItem setRightBarButtonItem:submitItem animated:YES];
    [submitItem release];
    [UIView animateWithDuration:0.2 animations:^{
        wheel.contentView.transform = CGAffineTransformRotate(wheel.contentView.transform, -M_PI / 24);
    }];


}

- (void)keyboardDidShow:(NSNotification *)note {
    NSLog(@"%@",[note userInfo]);
    NSDictionary *userInfo = [note userInfo];
    CGRect kbFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect rect = commentTextView.frame;
    if (kCommentTextViewHeight > CGRectGetMinY(kbFrame) - rect.origin.y - 80) {
        rect.size.height = CGRectGetMinY(kbFrame) - rect.origin.y - 80;
    }
    commentTextView.frame = rect;
    NSLog(@"%@",commentTextView);
}


- (NSInteger)numberOfPieceInSpinWheel:(SpinWheel *)SpinWheel {
    return 12;
}



- (SWPiece *)spinWheel:(SpinWheel *)spinWheel pieceForIndex:(NSInteger)index {
    SWPiece *piece = [spinWheel dequeueReusablePiece];
    if (piece== nil) {
        piece = [[[SWPiece alloc] initWithImage:nil] autorelease];
    }
    
    if (index == 0) {
        piece.titleLabel.text = nil;
    } else {
        piece.titleLabel.text = [NSString stringWithFormat:@"%d",index - 1];
    }

    
    return piece;
}



- (void)spinWheel:(SpinWheel *)spinWheel didSpinToIndex:(NSInteger)index {
    NSLog(@"%@,index : %d",NSStringFromSelector(_cmd),index);
//    SWPiece *piece = [spinWheel pieceForIndex:index];
//    piece.titleLabel.backgroundColor = [UIColor redColor];
}


- (void)submitAction:(UIBarButtonItem *)item {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提交" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
