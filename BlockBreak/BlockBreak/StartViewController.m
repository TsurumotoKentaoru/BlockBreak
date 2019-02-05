//
//  StartViewController.m
//  BlockBreak
//
//  Created by 鶴本賢太朗 on 2016/02/16.
//  Copyright © 2016年 鶴本賢太朗. All rights reserved.
//

#import "StartViewController.h"

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)transformPlayView:(id)sender
{
    [self performSegueWithIdentifier:@"PushStart" sender:nil];
}

@end
