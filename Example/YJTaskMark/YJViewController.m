//
//  YJViewController.m
//  YJTaskMark
//
//  Created by lyj on 07/04/2019.
//  Copyright (c) 2019 lyj. All rights reserved.
//

#import "YJViewController.h"
#import "TestEngineViewController.h"
@interface YJViewController ()

@end

@implementation YJViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    TestEngineViewController *testVC = [[TestEngineViewController alloc] init];
    [self.navigationController pushViewController:testVC animated:YES];
}

@end
