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

#import "IITableView.h"

@interface ViewController () <SpinWheelDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController {
    UIButton *finishButton;
    SpinWheel *wheel;
}


- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"filter_foot_bg"]];
    
    wheel = [[SpinWheel alloc]initWithFrame:self.view.bounds];
    wheel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleWidth;
    wheel.center = self.view.center;
    wheel.delegate = self;
    [self.view addSubview:wheel];
    
    
//    UIImageView *spinMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"content_mask"]];
//
//    spinMask.userInteractionEnabled = YES;
//    wheel.contentMask = spinMask;
//    finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [finishButton setImage:[UIImage imageNamed:@"finish_button"] forState:UIControlStateNormal];
//    [finishButton setImage:[UIImage imageNamed:@"finish_button_clicked"] forState:UIControlStateHighlighted];
//    finishButton.frame = CGRectMake(0, 0, 100, 40);
//    finishButton.center = CGPointMake(150, CGRectGetHeight(spinMask.frame) * 0.5);
//    [wheel.contentMask addSubview:finishButton];
//    [finishButton addTarget:self action:@selector(finishSpinAction:) forControlEvents:UIControlEventTouchUpInside];
//    [spinMask release];

    [super viewDidLoad];

}

- (IBAction)finishSpinAction:(UIButton *)sender {
    sender.selected = !sender.selected;

    [UIView animateWithDuration:0.2 animations:^{
        wheel.transform = sender.selected?CGAffineTransformMakeTranslation(-250, 0):CGAffineTransformIdentity;
    }];

}

- (void)awakeFromNib {
    
}

- (void)viewWillLayoutSubviews {
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"sdf");
}

- (void)viewDidAppear:(BOOL)animated {
    
}


- (NSInteger)numberOfPieceInSpinWheel:(SpinWheel *)SpinWheel {
    return 12;
}



- (SWPiece *)spinWheel:(SpinWheel *)spinWheel pieceForIndex:(NSInteger)index {
    SWPiece *piece = [spinWheel dequeueReusablePiece];
    if (piece== nil) {
        piece = [[[SWPiece alloc] initWithImage:spinWheel.sectorImage] autorelease];
    }
    
    piece.titleLabel.text = [NSString stringWithFormat:@"%d",index];

    
    return piece;
}



- (void)spinWheel:(SpinWheel *)spinWheel didSpinToIndex:(NSInteger)index {
    NSLog(@"%@,index : %d",NSStringFromSelector(_cmd),index);
//    SWPiece *piece = [spinWheel pieceForIndex:index];
//    piece.titleLabel.backgroundColor = [UIColor redColor];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
