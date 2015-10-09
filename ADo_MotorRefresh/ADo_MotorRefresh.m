//
//  ADo_MotorRefresh.m
//  ADo_MotorRefresh
//
//  Created by 杜 维欣 on 15/9/9.
//  Copyright (c) 2015年 nododo. All rights reserved.
//

#import "ADo_MotorRefresh.h"
#import "UIView+Extension.h"
#import "MotorView.h"

typedef enum : NSUInteger {
    ADo_RefreshStateInit,
    ADo_RefreshStateCanRefresh,
    ADo_RefreshStateRefreshing,
    ADo_RefreshStateEnd,
} ADo_RefreshState;


static float motorW = 64.f;
static float extentionDistance = 20.f;


@interface ADo_MotorRefresh ()
@property (nonatomic,weak)UIScrollView *refreshView;
@property (nonatomic,assign)float distance;
@property (nonatomic,copy)ADo_RefreshBlock refreshBlock;
@property (nonatomic,assign)ADo_RefreshState refreshState;

@end

@implementation ADo_MotorRefresh
{
    MotorView *motorView;
}

- (instancetype)initADo_RefreshWithScrollView:(UIScrollView *)scrollView
{
    self = [super initWithFrame:CGRectMake(scrollView.centerX - motorW / 2, - motorW, motorW, motorW)];
    if (self) {
        self.refreshView = scrollView;
        motorView = [[MotorView alloc] initWithFrame:self.bounds];
        [self.refreshView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self addSubview:motorView];
        [self.refreshView insertSubview:self atIndex:0];
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.refreshState == ADo_RefreshStateRefreshing)
    {
        return;
    }
    if (self.refreshView.tracking == NO)
    {
        if (self.refreshState == ADo_RefreshStateCanRefresh) {
            self.refreshState = ADo_RefreshStateRefreshing;
            [UIView animateWithDuration:0.3 animations:^{
                [motorView preToLoad];
                self.refreshView.contentInset = UIEdgeInsetsMake(motorW + extentionDistance, 0, 0, 0);
                
            } completion:^(BOOL finished) {
                self.refreshState = ADo_RefreshStateInit;
                [motorView loading];
                self.refreshBlock();
            }];
        }
    }else
    {
        CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        if (contentOffset.y < 0) {
            
            float distance = fabs(contentOffset.y);
            if (distance < 20) {
                return;
            }else
            {
                motorView.fireRate = MIN((distance - 20) / 64, 1.f);
                if (distance > 64) {
                    self.refreshState = ADo_RefreshStateCanRefresh;
                }else
                {
                    self.refreshState = ADo_RefreshStateInit;
                }
            }
        }
    }
}


- (void)addRefreshBlock:(ADo_RefreshBlock)refreshBlock
{
    self.refreshBlock = refreshBlock;
}


- (void)endRefresh
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.refreshView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    } completion:^(BOOL finished) {
        
        [motorView reset];
    }];
    
}

@end
