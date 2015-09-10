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
static float motorW = 64.f;


@interface ADo_MotorRefresh ()
@property (nonatomic,weak)UIScrollView *refreshView;
@property (nonatomic,assign)float distance;
@property (nonatomic,copy)ADo_RefreshBlock refreshBlock;
@end

@implementation ADo_MotorRefresh
{
    MotorView *motorView;
    BOOL canLoad;
    BOOL loading;
}

- (instancetype)initADo_RefreshWithScrollView:(UIScrollView *)scrollView
{
    self = [super initWithFrame:CGRectMake(scrollView.centerX - motorW / 2, - 64, motorW, motorW)];
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
    CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
    float distance = fabs(contentOffset.y);
    if (loading) {
        return;
    }
    if (self.refreshView.tracking == NO && canLoad && distance > 64) {
        [UIView animateWithDuration:0.3 animations:^{
            loading = YES;
            self.refreshView.contentInset = UIEdgeInsetsMake(84, 0, 0, 0);
        } completion:^(BOOL finished) {
            [motorView loading];
            self.refreshBlock();
        }];
    }else
    {
        if (distance < 20) {
            return;
        }else{
            
            motorView.fireRate = MIN((distance - 20) / 64, 1.f);
            if (distance > 64) {
                canLoad = YES;
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
        canLoad = NO;
        loading = NO;
        [motorView reset];
    }];
    
}

@end
