//
//  Created by zlcode on 2017/4/19.
//  Copyright © 2017年 zlcode. All rights reserved.
//

#import "BrightnessVolumeView.h"
#import <AVFoundation/AVFoundation.h>

@implementation BrightnessVolumeView

#pragma mark - xib初始化入口
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addPanGesture];
        [BrightnessView sharedBrightnessView];
    }
    return self;
}

#pragma mark - 代码初始化入口
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addPanGesture];
        [BrightnessView sharedBrightnessView];
    }
    return self;
}

#pragma mark - 添加拖动手势
- (void)addPanGesture{
    // 拖动手势
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panRecognizer];
}

#pragma mark -  处理音量和亮度
- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint location = [recognizer locationInView:self];
    CGPoint point = [recognizer translationInView:recognizer.view];
    
    // 音量
    if (location.x > ZLScreenWidth * 0.5) {
        
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            self.lastVolume = [self bfGetCurrentVolume];
        }
        
        float volumeDelta = point.y / (recognizer.view.bounds.size.height) * 0.5;
        float newVolume = self.lastVolume - volumeDelta;
        
        [self bfSetVolume:newVolume];
        
    } else {// 亮度
        
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            self.lastBrightness = [UIScreen mainScreen].brightness;
        }
        
        float volumeDelta = point.y / (recognizer.view.bounds.size.height) * 0.5;
        float newVolume = self.lastBrightness - volumeDelta;
        
        [[UIScreen mainScreen] setBrightness:newVolume];
    }
}

#pragma mark -  兼容iOS 7.0前后的音量控制
- (float)bfGetCurrentVolume {
    // 通过控制系统声音 控制音量
    if (ZLSystemVersion >= 7) {
        if (_volumeViewSlider) {
            return _volumeViewSlider.value;
        }
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                _volumeViewSlider = (UISlider*)view;
                break;
            }
        }
        
        // 解决初始状态下获取不到系统音量
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        CGFloat systemVolume = audioSession.outputVolume;
        
        return systemVolume;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        // 过期api写在这里不会有警告
        return [[MPMusicPlayerController applicationMusicPlayer] volume];
#pragma clang diagnostic pop
    }
}

#pragma mark - 控制音量
- (void)bfSetVolume:(float)newVolume {
    // 通过控制系统声音 控制音量
    newVolume = newVolume > 1 ? 1 : newVolume;
    newVolume = newVolume < 0 ? 0 : newVolume;
    
    if (ZLSystemVersion >= 7) {
        [self.volumeViewSlider setValue:newVolume animated:NO];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        // 过期api写在这里不会有警告
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:newVolume];
#pragma clang diagnostic pop
    }
}

@end
