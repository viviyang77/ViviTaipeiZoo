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

@interface ZooTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet ZooNavigationBar *navigationBar;
@property (assign, nonatomic) BOOL calculatedNavBarHeight;  // 是否依照不同status bar調整navigation bar高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *spinnerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) ZooViewModel *viewModel;
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
//    NSLog(@"scrollViewWillBeginDragging");
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY == 0) {
        // contentOffset.y是0的話不做任何動作
        return;
    }
    
    CGFloat finalNavigationBarHeight = self.navigationBarHeightConstraint.constant;
    
    CGFloat maxHeight = self.navigationBar.maxHeight;
    CGFloat minHeight = self.navigationBar.minHeight;
    BOOL shouldSetOffsetToZero = NO;
    
//    NSLog(@">>> y: %f, current height: %f", scrollView.contentOffset.y, finalNavigationBarHeight);

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
            // Bouncing，不做任何動作
            return;
        }
        else {
            // Navigation bar最小不可小於minHeight
            finalNavigationBarHeight = MIN(maxHeight, MAX(minHeight, finalNavigationBarHeight - offsetY));
            
            // 如果已經知道等等會向上滑到0，就不改變offset.y
            if (!(self.willEndAtZero && self.isScrollingUpwards)) {
                shouldSetOffsetToZero = YES;
            }
        }
    }
    
    self.navigationBarHeightConstraint.constant = finalNavigationBarHeight;
    
//    NSLog(@"self.navigationBarHeightConstraint.constant: %f", self.navigationBarHeightConstraint.constant);

    if (shouldSetOffsetToZero) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    NSLog(@">>> scrollViewWillEndDragging, target y: %f, velocity.y: %f", (*targetContentOffset).y, velocity.y);
    if ((*targetContentOffset).y == 0) {
        self.willEndAtZero = YES;
    }
    if (velocity.y < 0) {
        self.isScrollingUpwards = YES;
    }
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@">>> scrollViewDidEndDragging");
//    self.startedDragging = NO;
//}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@">>> scrollViewDidEndDecelerating");
//}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    NSLog(@">>> scrollViewDidEndScrollingAnimation");
    if (self.willEndAtZero && self.isScrollingUpwards) {
        self.navigationBarHeightConstraint.constant = self.navigationBar.maxHeight;
    }
    
    self.willEndAtZero = NO;
    self.isScrollingUpwards = NO;
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

@end
