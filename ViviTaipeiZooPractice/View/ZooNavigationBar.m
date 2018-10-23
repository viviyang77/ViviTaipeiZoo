//
//  ZooNavigationBar.m
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi. All rights reserved.
//

#import "ZooNavigationBar.h"

@interface ZooNavigationBar ()

@property (strong, nonatomic) UIView *smallView;
@property (strong, nonatomic) UIView *largeView;

@end

@implementation ZooNavigationBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    if (![[NSBundle bundleForClass:self.class] pathForResource:NSStringFromClass(self.class) ofType:@"nib"]) {
        self = [super init];
    }
    else {
        self = [[[NSBundle bundleForClass:self.class] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] firstObject];
    }
    
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.smallView = [UIView new];
    self.largeView = [UIView new];
    [self addSubview:self.smallView];
    [self addSubview:self.largeView];
    
    // 設定初始的最小/最大高度（不算status bar高度）
    _minHeight = 50.0;
    _maxHeight = 130.0;
    CGFloat minHeightWithoutStatusBar = _minHeight;
    CGFloat maxHeightWithoutStatusBar = _maxHeight;

    [self.smallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([self statusBarHeight]);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(minHeightWithoutStatusBar);
    }];
    [self.largeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(maxHeightWithoutStatusBar);
    }];
}

- (CGFloat)minHeight {
    if (!_minHeight) {
        _minHeight = 44.0;
    }
    return [self heightByAddingStatusBarHeight:_minHeight];
}

- (CGFloat)maxHeight {
    if (!_maxHeight) {
        _maxHeight = 100.0;
    }
    return [self heightByAddingStatusBarHeight:_maxHeight];
}

- (CGFloat)heightByAddingStatusBarHeight:(CGFloat)originalHeight {
    CGFloat height = originalHeight + [self statusBarHeight];
    
    // 若熱點或in-call status bar顯示在螢幕上，rootViewOriginY會大於0，需要減去多出的高度
    CGFloat rootViewOriginY = CGRectGetMinY([UIApplication sharedApplication].delegate.window.rootViewController.view.frame);
    return height - rootViewOriginY;
}

- (CGFloat)statusBarHeight {
    return CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}

#pragma mark - smallView/largeView 相關

- (void)updateSmallView:(UIView *)subview {
    [self addSubview:subview toView:self.smallView];
}

- (void)updateLargeView:(UIView *)subview {
    [self addSubview:subview toView:self.largeView];
}

- (void)addSubview:(UIView *)subview toView:(UIView *)view {
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [view addSubview:subview];
    [subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
}

- (void)updateSubviewTransparencyWithHeight:(CGFloat)navBarHeight {
    CGFloat minHeight = self.minHeight;
    CGFloat maxHeight = self.maxHeight;
    CGFloat percentage = 0;
    if (navBarHeight <= minHeight) {
        percentage = 0;
    }
    else if (navBarHeight >= maxHeight) {
        percentage = 1;
    }
    else {
        percentage = (navBarHeight - minHeight) / (maxHeight - minHeight);
    }

    self.smallView.alpha = 1 - percentage;
    self.largeView.alpha = percentage;
}

@end
