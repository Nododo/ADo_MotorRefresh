//
//  ADo_MotorRefresh.h
//  ADo_MotorRefresh
//
//  Created by 杜 维欣 on 15/9/9.
//  Copyright (c) 2015年 nododo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ADo_RefreshBlock)();
@interface ADo_MotorRefresh : UIView
- (instancetype)initADo_RefreshWithScrollView:(UIScrollView *)scrollView;
- (void)addRefreshBlock:(ADo_RefreshBlock)refreshBlock;
- (void)endRefresh;
@end
