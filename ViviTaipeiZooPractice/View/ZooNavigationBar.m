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
        _minHeight = 44.0;
    }
    return _minHeight;
}

- (CGFloat)maxHeight {
    if (!_maxHeight) {
        _maxHeight = 64.0;
    }
    
    CGFloat height = _maxHeight + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat rootViewOriginY = CGRectGetMinY([UIApplication sharedApplication].delegate.window.rootViewController.view.frame);
    return height - rootViewOriginY;
}

@end
