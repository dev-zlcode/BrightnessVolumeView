//
//  Created by zlcode on 2017/4/19.
//  Copyright © 2017年 zlcode. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MPMusicPlayerController.h>
#import <MediaPlayer/MediaPlayer.h>

#import "BrightnessView.h"

@interface BrightnessVolumeView : UIView

@property (nonatomic, strong) UISlider* volumeViewSlider; // 获取MediaPlayer的Slider
@property (nonatomic, assign) float lastVolume; // 上一次调节音量时的音量大小
@property (nonatomic, assign) float lastBrightness; // 上一次调节亮度时的亮度大小

@end
