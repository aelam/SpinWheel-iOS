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

@implementation ViewController

- (void)viewDidLoad
{
    SpinWheel *wheel = [[SpinWheel alloc]initWithFrame:CGRectMake(-150, 0, 320, 480)];
//    wheel.center = self.view.center;
    wheel.delegate = self;
    [self.view addSubview:wheel];
    [wheel release];
    
    [super viewDidLoad];

}

- (NSInteger)numberOfPieceInSpinWheel:(SpinWheel *)SpinWheel {
    return 12;
}



- (SWPiece *)spinWheel:(SpinWheel *)spinWheel pieceForIndex:(NSInteger)index {
    UIImage *image = [UIImage imageNamed:@"assets/piece.png"];
    
    SWPiece *piece = [[SWPiece alloc] initWithImage:image];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(piece.frame) - 40, 40, 30, 15)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = [NSString stringWithFormat:@"%d",index];
    [piece addSubview:label];
    return [piece autorelease];
}

- (void)spinWheel:(SpinWheel *)spinWheel didSpinToIndex:(NSInteger)index {
    NSLog(@"%s,index : %d",_cmd,index);
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
