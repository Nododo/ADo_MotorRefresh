//
//  MotorView.h
//  ADo_MotorRefresh
//
//  Created by 杜 维欣 on 15/9/9.
//  Copyright (c) 2015年 nododo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MotorView : UIView

@property (nonatomic,assign)float fireRate;

- (void)loading;

- (void)preToLoad;

- (void)reset;
@end
