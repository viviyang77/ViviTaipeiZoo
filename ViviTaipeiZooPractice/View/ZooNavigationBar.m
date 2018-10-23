//
//  ZooNavigationBar.m
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi. All rights reserved.
//

#import "ZooNavigationBar.h"

@interface ZooNavigationBar ()
@end

@implementation ZooNavigationBar

- (instancetype)init {
    if (![[NSBundle bundleForClass:self.class] pathForResource:NSStringFromClass(self.class) ofType:@"nib"]) {
        self = [super init];
    }
    else {
        self = [[[NSBundle bundleForClass:self.class] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] firstObject];
    }
    return self;
}

- (CGFloat)minHeight {
    if (!_minHeight) {
        _minHeight = 20.0;
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
    CGFloat height = originalHeight + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat rootViewOriginY = CGRectGetMinY([UIApplication sharedApplication].delegate.window.rootViewController.view.frame);
    return height - rootViewOriginY;
}

@end
