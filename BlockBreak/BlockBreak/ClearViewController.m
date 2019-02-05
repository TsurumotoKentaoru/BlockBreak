//
//  ClearViewController.m
//  BlockBreak
//
//  Created by 鶴本賢太朗 on 2016/02/18.
//  Copyright © 2016年 鶴本賢太朗. All rights reserved.
//

#import "ClearViewController.h"

@implementation ClearViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)PushPlayAgain:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
