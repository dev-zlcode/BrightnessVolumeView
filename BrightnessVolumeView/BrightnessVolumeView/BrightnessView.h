//
//  Created by zlcode on 2017/4/19.
//  Copyright © 2017年 zlcode. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZLScreenWidth [UIScreen mainScreen].bounds.size.width
#define ZLScreenHeight [UIScreen mainScreen].bounds.size.height
#define ZLSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface BrightnessView : UIView

+ (instancetype)sharedBrightnessView;

@end
