//
//  ViewController.m
//  BrightnessVolumeView
//
//  Created by admin on 2017/4/19.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"

#import "BrightnessVolumeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 使用方法一 xib使用 拖一个UIView修改继承类为BrightnessVolumeView就可以了
    
    // 使用方法二 全代码使用
    BrightnessVolumeView *brightnessVolumeView = [[BrightnessVolumeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:brightnessVolumeView];
}

@end
