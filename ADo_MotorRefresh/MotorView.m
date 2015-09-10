//
//  MotorView.m
//  ADo_MotorRefresh
//
//  Created by 杜 维欣 on 15/9/9.
//  Copyright (c) 2015年 nododo. All rights reserved.
//

#import "MotorView.h"

@implementation MotorView
{
    UIImageView *topView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *bottomView = [[UIImageView alloc] initWithFrame:self.bounds];
        bottomView.image = [UIImage imageNamed:@"load_icon_dial"];
        [self addSubview:bottomView];
        topView = [[UIImageView alloc] initWithFrame:self.bounds];
        topView.image = [UIImage imageNamed:@"load_icon_pointer"];
        [self addSubview:topView];
    }
    return self;
}

- (void)setFireRate:(float)fireRate
{
    _fireRate = fireRate;
    topView.transform = CGAffineTransformMakeRotation(_fireRate * 7 / 5 * M_PI);
}


- (void)loading
{
    CAKeyframeAnimation *rotation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.values = @[@(-0.75 *M_PI),@(-1.5 *M_PI),@(-1.25 *M_PI)];
    rotation.fillMode = kCAFillModeForwards;
    rotation.removedOnCompletion = NO;
    rotation.duration = 1.0f;
    [topView.layer addAnimation:rotation forKey:nil];
    
}

- (void)reset
{
    _fireRate = 0;
    [topView.layer removeAllAnimations];
    topView.transform = CGAffineTransformIdentity;
}


@end
