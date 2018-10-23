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
@synthesize minHeight = _minHeight;
@synthesize maxHeight = _maxHeight;

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
    self.smallView.alpha = 0;   // 預設隱藏
    self.largeView = [UIView new];
    [self addSubview:self.smallView];
    [self addSubview:self.largeView];
    
    // 設定初始的最小/最大高度（不算status bar高度）
    _minHeight = 50.0;
    _maxHeight = 130.0;
    
    [self updateSmallViewHeight];
    [self updateLargeViewHeight];
}

#pragma mark - 高度相關

- (CGFloat)minHeight {
    if (!_minHeight) {
        _minHeight = 44.0;
    }
    return [self heightByAddingStatusBarHeight:_minHeight];
}

- (void)setMinHeight:(CGFloat)minHeight {
    _minHeight = minHeight;
    [self updateSmallViewHeight];
}

- (CGFloat)maxHeight {
    if (!_maxHeight) {
        _maxHeight = 100.0;
    }
    return [self heightByAddingStatusBarHeight:_maxHeight];
}

- (void)setMaxHeight:(CGFloat)maxHeight {
    _maxHeight = maxHeight;
    [self updateLargeViewHeight];
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

- (void)updateSmallViewHeight {
    CGFloat minHeightWithoutStatusBar = _minHeight;
    
    [self.smallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([self statusBarHeight]);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(minHeightWithoutStatusBar);
    }];
}

- (void)updateLargeViewHeight {
    CGFloat maxHeightWithoutStatusBar = _maxHeight;
    [self.largeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(maxHeightWithoutStatusBar);
    }];
}

- (void)updateSubviewTransparencyWithHeight:(CGFloat)navBarHeight {
    if (!self.heightConstraint) {
        // 若沒有被assign heightConstraint，不需調整view的transparency
        return;
    }
    
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

#pragma mark - Scrolling 相關

- (BOOL)updateHeightWithContentOffsetY:(CGFloat)offsetY {
    if (!self.heightConstraint) {
        // 若沒有被assign heightConstraint，不需調整高度
        return NO;
    }
    
    if (offsetY == 0) {
        // contentOffset.y是0的話不做任何動作
        return NO;
    }
    
    CGFloat finalNavigationBarHeight = self.heightConstraint.constant;
    CGFloat minHeight = self.minHeight;
    CGFloat maxHeight = self.maxHeight;
    BOOL shouldSetOffsetToZero = NO;
    
    if (offsetY > 0) {
        // 手向上滑⬆️
        // Navigation bar最高不可超過maxHeight
        finalNavigationBarHeight = MIN(maxHeight, MAX(minHeight, finalNavigationBarHeight - offsetY));
        
        // Navigation bar要縮到最小的時候scrollView才能開始滑動，在那之前contentOffset.y都要是0
        if (finalNavigationBarHeight > minHeight) {
            shouldSetOffsetToZero = YES;
        }
    }
    else if (offsetY < 0) {
        // 手向下滑⬇️
        if (finalNavigationBarHeight == maxHeight) {
            // 已在頂端，向下滑代表bouncing，不做任何動作
            return NO;
        }
        else {
            // Navigation bar最小不可小於minHeight
            finalNavigationBarHeight = MIN(maxHeight, MAX(minHeight, finalNavigationBarHeight - offsetY));
            
            // 如果已經知道等等會向上滑到0，就不改變offset.y
            if (!self.isScrollingToZeroUpwards) {
                shouldSetOffsetToZero = YES;
            }
        }
    }
    [self setHeightTo:finalNavigationBarHeight shouldAnimate:NO];
    return shouldSetOffsetToZero;
}

- (void)adjustHeightWhenScrollingEnds {
    if (!self.heightConstraint) {
        // 若沒有被assign heightConstraint，不需調整高度
        return;
    }
    
    if (self.isScrollingToZeroUpwards) {
        // 即將向上滑到頂端，直接將navigation bar高度設定為maxHeight
        [self setHeightTo:self.maxHeight shouldAnimate:YES];
    }
    else {
        [self adjustHeightIfInBetween];
    }
    
    self.isScrollingToZeroUpwards = NO;
}

- (void)setHeightTo:(CGFloat)height shouldAnimate:(BOOL)shouldAnimate {
    if (!self.heightConstraint) {
        // 若沒有被assign heightConstraint，不需調整高度
        return;
    }
    
    self.heightConstraint.constant = height;
    
    if (shouldAnimate) {
        [self.superview setNeedsLayout];
        [UIView animateWithDuration:0.3 animations:^{
            [self.superview layoutIfNeeded];
            [self updateSubviewTransparencyWithHeight:height];
        }];
    }
    else {
        [self updateSubviewTransparencyWithHeight:height];
    }
}

- (void)adjustHeightIfInBetween {
    if (!self.heightConstraint) {
        // 若沒有被assign heightConstraint，不需調整高度
        return;
    }
    
    CGFloat minHeight = self.minHeight;
    CGFloat maxHeight = self.maxHeight;
    CGFloat halfHeight = minHeight + (maxHeight - minHeight) / 2.0;
    CGFloat currentNavBarHeight = self.heightConstraint.constant;
    CGFloat finalNavBarHeight = currentNavBarHeight;
    
    if (currentNavBarHeight > minHeight &&
        currentNavBarHeight < maxHeight) {
        if (currentNavBarHeight >= halfHeight) {
            finalNavBarHeight = self.maxHeight;
        }
        else {
            finalNavBarHeight = self.minHeight;
        }
        
        [self setHeightTo:finalNavBarHeight shouldAnimate:YES];
    }
}

@end
