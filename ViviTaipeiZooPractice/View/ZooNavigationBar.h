//
//  ZooNavigationBar.h
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZooNavigationBar : UIView

@property (weak, nonatomic) NSLayoutConstraint *heightConstraint;
@property (assign, nonatomic) CGFloat minHeight;
@property (assign, nonatomic) CGFloat maxHeight;

@property (assign, nonatomic) BOOL isScrollingToZeroUpwards;    // Upwards = back to top

/**
 設定當高度為最小時需要顯示的view。

 @param subview 當高度為最小時需要顯示的view
 */
- (void)updateSmallView:(UIView *)subview;

/**
 設定當高度為最大時需要顯示的view。

 @param subview 當高度為最大時需要顯示的view
 */
- (void)updateLargeView:(UIView *)subview;

/**
 依據當下scrollView裡的位置決定ZooNavigationBar的高度。

 @param contentOffsetY 當下scrollView的位置
 @return 若需要把相關scrollView的contentOffset設定為0，回傳YES;
 */
- (BOOL)updateHeightWithContentOffsetY:(CGFloat)contentOffsetY;

/**
 依據當下的高度決定高度該縮小或放大。
 */
- (void)adjustHeightWhenScrollingEnds;

/**
 設定高度，可選擇是否需要動畫效果。

 @param height 高度
 @param shouldAnimate 是否需要動畫
 */
- (void)setHeightTo:(CGFloat)height shouldAnimate:(BOOL)shouldAnimate;

@end

NS_ASSUME_NONNULL_END
