//
//  Created by zlcode on 2017/4/19.
//  Copyright © 2017年 zlcode. All rights reserved.
//

#import "BrightnessView.h"

@interface BrightnessView ()

@property (nonatomic, strong) UIImageView		*backImage;
@property (nonatomic, strong) UILabel			*title;
@property (nonatomic, strong) UIView			*brightnessLevelView;
@property (nonatomic, strong) NSMutableArray	*tipArray;
@property (nonatomic, strong) NSTimer			*timer;

@end

@implementation BrightnessView

#pragma mark - 懒加载
-(UILabel *)title {
    if (!_title) {
        _title   = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 30)];
        _title.font  = [UIFont boldSystemFontOfSize:16];
        _title.textColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.text   = @"亮度";
    }
    return _title;
}

- (UIImageView *)backImage {
    
    if (!_backImage) {
        _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 79, 76)];
        _backImage.image  = [UIImage imageNamed:getResourceFromBundleFileName(@"brightness")];
    }
    return _backImage;
}

-(UIView *)brightnessLevelView {
    
    if (!_brightnessLevelView) {
        _brightnessLevelView  = [[UIView alloc]initWithFrame:CGRectMake(13, 132, self.bounds.size.width - 26, 7)];
        _brightnessLevelView.backgroundColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
        [self addSubview:_brightnessLevelView];
    }
    return _brightnessLevelView;
}

#pragma mark - 单例
+ (instancetype)sharedBrightnessView {
	static BrightnessView *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[BrightnessView alloc] init];
		[[[UIApplication sharedApplication].windows firstObject] addSubview:instance];
	});
	return instance;
}

- (instancetype)init {
	if (self = [super init]) {
        [self setupUI];
	}
	return self;
}

- (void)setupUI {
    self.frame = CGRectMake(ZLScreenWidth * 0.5, ZLScreenHeight * 0.5 - 20, 155, 155);
    self.layer.cornerRadius  = 10;
    self.layer.masksToBounds = YES;
    
    // 毛玻璃效果
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
    [self addSubview:toolbar];
    
    [self addSubview:self.backImage];
    [self addSubview:self.title];
    [self addSubview:self.brightnessLevelView];
    
    [self createTips];
    [self addStatusBarNotification];
    [self addKVOObserver];
    
    self.alpha = 0.0;
}

#pragma makr - 创建 Tips
- (void)createTips {
	
	self.tipArray = [NSMutableArray arrayWithCapacity:16];
	CGFloat tipW = (self.brightnessLevelView.bounds.size.width - 17) / 16;
	CGFloat tipH = 5;
	CGFloat tipY = 1;
    
    for (int i = 0; i < 16; i++) {
        CGFloat tipX   = i * (tipW + 1) + 1;
        UIImageView *image    = [[UIImageView alloc] init];
        image.backgroundColor = [UIColor whiteColor];
        image.frame           = CGRectMake(tipX, tipY, tipW, tipH);
		[self.brightnessLevelView addSubview:image];
		[self.tipArray addObject:image];
	}
	[self updateBrightnessLevel:[UIScreen mainScreen].brightness];
}

#pragma makr - 通知 KVO
- (void)addStatusBarNotification {
    /** 注册 UIApplicationDidChangeStatusBarOrientationNotification -状态栏方向改变
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationNotification:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)addKVOObserver {
	[[UIScreen mainScreen] addObserver:self
							forKeyPath:@"brightness"
							   options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
                       context:(void *)context {
    
    CGFloat levelValue = [change[@"new"] floatValue];

    [self removeTimer];
    [self appearBrightnessView];
    [self updateBrightnessLevel:levelValue];
}

#pragma mark - 状态栏方向改变通知
- (void)statusBarOrientationNotification:(NSNotification *)notify {
	[self setNeedsLayout];
}

#pragma mark - Brightness显示 隐藏
- (void)appearBrightnessView {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self addtimer];
    }];
}

- (void)disAppearBrightnessView {
    if (self.alpha == 1.0) {
		[UIView animateWithDuration:0.5 animations:^{
			self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeTimer];
		}];
	}
}

#pragma mark - 定时器
- (void)addtimer {
	if (self.timer) {
		return;
	}
	self.timer = [NSTimer timerWithTimeInterval:2
										 target:self
									   selector:@selector(disAppearBrightnessView)
									   userInfo:nil
										repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 更新亮度值
- (void)updateBrightnessLevel:(CGFloat)brightnessLevel {
	CGFloat stage = 1 / 15.0;
	NSInteger level = brightnessLevel / stage;
    for (int i = 0; i < self.tipArray.count; i++) {
		UIImageView *img = self.tipArray[i];
        if (i <= level) {
			img.hidden = NO;
		} else {
			img.hidden = YES;
		}
	}
}

#pragma mark - 更新布局
- (void)layoutSubviews {
	[super layoutSubviews];
    //InterfaceOrientation值
    UIInterfaceOrientation currInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (currInterfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            self.center = CGPointMake(ZLScreenWidth * 0.5, (ZLScreenHeight - 10) * 0.5);
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            self.center = CGPointMake(ZLScreenWidth * 0.5, (ZLScreenHeight) * 0.5);
        }
            break;
        default:
            break;
    }
	self.backImage.center = CGPointMake(155 * 0.5, 155 * 0.5);
    [self.superview bringSubviewToFront:self];
}

#pragma mark - 获取bundle资源
NSString* getResourceFromBundleFileName( NSString * filename) {
    NSString * vodPlayerBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resource.bundle"] ;
    NSBundle *resoureBundle = [NSBundle bundleWithPath:vodPlayerBundle];
    
    if (resoureBundle && filename)
    {
        NSString * bundlePath = [[resoureBundle resourcePath ] stringByAppendingPathComponent:filename];
        
        return bundlePath;
    }
    return nil ;
}

#pragma mark - 销毁
- (void)dealloc {
    [[UIScreen mainScreen] removeObserver:self forKeyPath:@"brightness"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
