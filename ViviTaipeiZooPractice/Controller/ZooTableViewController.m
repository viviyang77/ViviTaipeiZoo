//
//  ZooTableViewController.m
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi. All rights reserved.
//

#import "ZooTableViewController.h"
#import "ZooNavigationBar.h"
#import "ZooTableViewCell.h"
#import "ZooViewModel.h"
#import "SVProgressHUD.h"

const CGFloat navBarAnimationDuration = 0.3;

@interface ZooTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet ZooNavigationBar *navigationBar;
@property (assign, nonatomic) BOOL calculatedNavBarHeight;  // 是否依照不同status bar調整navigation bar高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *spinnerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) ZooViewModel *viewModel;

// For navigation bar height transition
@property (assign, nonatomic) CGFloat minNavBarHeight;
@property (assign, nonatomic) CGFloat maxNavBarHeight;
@property (assign, nonatomic) BOOL willEndAtZero;
@property (assign, nonatomic) BOOL isScrollingUpwards;  // Upwards = back to top

@end

@implementation ZooTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    [self setUpData];
    [self setUpString];
}

- (void)setUpUI {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

- (void)setUpData {
    self.minNavBarHeight = self.navigationBar.minHeight;
    self.maxNavBarHeight = self.navigationBar.maxHeight;
    
    self.viewModel = [ZooViewModel new];
    [self fetchZooInformationDataIfInitial:YES];
}

- (void)setUpString {
    //TODO: Navigation bar title & text
}

- (void)viewWillLayoutSubviews {
    if (!self.calculatedNavBarHeight) {
        self.navigationBarHeightConstraint.constant = self.navigationBar.maxHeight;
        self.calculatedNavBarHeight = YES;
    }
}

#pragma mark - UIScrollView

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    NSLog(@">>> scrollViewWillBeginDragging");
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY == 0) {
        // contentOffset.y是0的話不做任何動作
        return;
    }
    
    CGFloat finalNavigationBarHeight = self.navigationBarHeightConstraint.constant;
    BOOL shouldSetOffsetToZero = NO;
    
//    NSLog(@">>> y: %f, current height: %f", scrollView.contentOffset.y, finalNavigationBarHeight);

    if (offsetY > 0) {
        // 手向上滑⬆️
        // Navigation bar最高不可超過maxHeight
        finalNavigationBarHeight = MIN(self.maxNavBarHeight, MAX(self.minNavBarHeight, finalNavigationBarHeight - offsetY));
        
        // Navigation bar要縮到最小的時候scrollView才能開始滑動，在那之前contentOffset.y都要是0
        if (finalNavigationBarHeight > self.minNavBarHeight) {
            shouldSetOffsetToZero = YES;
        }
    }
    else if (offsetY < 0) {
        // 手向下滑⬇️
        if (finalNavigationBarHeight == self.maxNavBarHeight) {
            // Bouncing，不做任何動作
            return;
        }
        else {
            // Navigation bar最小不可小於minHeight
            finalNavigationBarHeight = MIN(self.maxNavBarHeight, MAX(self.minNavBarHeight, finalNavigationBarHeight - offsetY));
            
            // 如果已經知道等等會向上滑到0，就不改變offset.y
            if (!(self.willEndAtZero && self.isScrollingUpwards)) {
                shouldSetOffsetToZero = YES;
            }
        }
    }
    
    self.navigationBarHeightConstraint.constant = finalNavigationBarHeight;
    
//    NSLog(@"=== self.navigationBarHeightConstraint.constant: %f", self.navigationBarHeightConstraint.constant);

    if (shouldSetOffsetToZero) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    NSLog(@">>> scrollViewWillEndDragging, target y: %f, velocity.y: %f", (*targetContentOffset).y, velocity.y);
    
    self.willEndAtZero = (*targetContentOffset).y == 0;
    self.isScrollingUpwards = velocity.y < 0;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@">>> scrollViewDidEndDragging");
    
    if (!decelerate) {
        // decelerate == NO表示user是慢慢滑動scrollView，被呼叫的時候scrollView已經停止滑動了，
        // 所以不會跑到scrollViewDidEndDecelerating
        [self adjustNavigationBarHeightWhenScrollingEnds];
    }
}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    NSLog(@">>> scrollViewWillBeginDecelerating");
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // User快速滑動scrollView後停止滑動時會呼叫到

//    NSLog(@">>> scrollViewDidEndDecelerating, willEndAtZero: %d, isScrollingUpwards: %d", self.willEndAtZero, self.isScrollingUpwards);
    
    [self adjustNavigationBarHeightWhenScrollingEnds];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.resultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZooTableViewCell *cell = (ZooTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ZooCell"];
    if (!cell) {
        cell = [[ZooTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZooCell"];
    }
    if (indexPath.row < self.viewModel.resultsArray.count) {
        [cell updateData:self.viewModel.resultsArray[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.viewModel.resultsArray.count - 5) {
        [self fetchZooInformationDataIfInitial:NO];
    }
}

#pragma mark -

- (void)fetchZooInformationDataIfInitial:(BOOL)isInitial {
    [self.viewModel fetchZooDataWithPrecondition:^{
        [self showLoadingView:YES shouldShowHud:isInitial];

    } completion:^(BOOL success, NSString *errorMessage) {
        if (success) {
            [self.tableView reloadData];
        }
        [self showLoadingView:NO shouldShowHud:isInitial];

        if (errorMessage.length > 0) {
            [SVProgressHUD showErrorWithStatus:errorMessage];
        }
    }];
}

- (void)showLoadingView:(BOOL)shouldShow shouldShowHud:(BOOL)shouldShowHud {
    if (shouldShow) {
        // 顯示
        if (shouldShowHud) {
            [SVProgressHUD show];
        }
        else {
            [self.spinner startAnimating];
            self.tableView.tableFooterView = self.spinnerView;
        }
    }
    else {
        // 關閉
        if (shouldShowHud) {
            [SVProgressHUD dismiss];
        }
        else {
            [self.spinner stopAnimating];
            self.tableView.tableFooterView = nil;
        }
    }
}

- (void)adjustNavigationBarHeightWhenScrollingEnds {
    if (self.willEndAtZero && self.isScrollingUpwards) {
        // 即將向上滑到頂端，直接將navigation bar高度設定為maxHeight
        
        NSLog(@">>> 直接設定成max");
        [self setNavigationBarHeightToMax];
    }
    else {
        [self adjustNavigationBarHeightIfInBetween];
    }
    
    self.willEndAtZero = NO;
    self.isScrollingUpwards = NO;
}

- (void)adjustNavigationBarHeightIfInBetween {
    CGFloat halfHeight = self.minNavBarHeight + (self.maxNavBarHeight - self.minNavBarHeight) / 2.0;
    CGFloat currentNavBarHeight = self.navigationBarHeightConstraint.constant;
    CGFloat finalNavBarHeight = currentNavBarHeight;
    
    if (currentNavBarHeight > self.minNavBarHeight &&
        currentNavBarHeight < self.maxNavBarHeight) {
        if (currentNavBarHeight >= halfHeight) {
            finalNavBarHeight = self.maxNavBarHeight;
        }
        else {
            finalNavBarHeight = self.minNavBarHeight;
        }
        
        self.navigationBarHeightConstraint.constant = finalNavBarHeight;
        [self.view setNeedsLayout];
        [UIView animateWithDuration:navBarAnimationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)setNavigationBarHeightToMax {
    self.navigationBarHeightConstraint.constant = self.navigationBar.maxHeight;
    [self.view setNeedsLayout];
    [UIView animateWithDuration:navBarAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
