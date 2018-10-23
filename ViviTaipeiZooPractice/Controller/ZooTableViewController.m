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
@property (assign, nonatomic) BOOL calculatedNavBarHeight;  // 是否已依照不同status bar調整navigation bar高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *largeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallTitleLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *spinnerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) ZooViewModel *viewModel;

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
    
    self.navigationBar.heightConstraint = self.navigationBarHeightConstraint;
    [self.navigationBar updateSmallView:self.smallTitleLabel];
    [self.navigationBar updateLargeView:self.largeTitleLabel];
}

- (void)setUpData {
    self.viewModel = [ZooViewModel new];
    [self fetchZooInformationDataIfInitial:YES];
}

- (void)setUpString {
    self.largeTitleLabel.text = @"🐯臺北市立動物園🐼";
    self.smallTitleLabel.text = @"🦁臺北市立動物園的動物們🐨";
}

- (void)viewWillLayoutSubviews {
    // 第一次進入畫面時需依照status bar高度調整navigation bar的高度
    if (!self.calculatedNavBarHeight) {
        [self.navigationBar setHeightTo:self.navigationBar.maxHeight shouldAnimate:NO];
        self.calculatedNavBarHeight = YES;
    }
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 讓navigation bar依據目前的contentOffset.y調整大小；
    // 若遇到需要將contentOffset.y重設為0的情況，重設contentOffset
    if ([self.navigationBar updateHeightWithContentOffsetY:offsetY]) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    // 設定參數以讓navigation bar之後設定高度
    self.navigationBar.isScrollingToZeroUpwards = (*targetContentOffset).y == 0 && velocity.y < 0;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        // decelerate == NO表示user是慢慢滑動scrollView，被呼叫的時候scrollView已經停止滑動了，
        // 不會跑到scrollViewDidEndDecelerating
        [self.navigationBar adjustHeightWhenScrollingEnds];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // User快速滑動scrollView後停止滑動時會呼叫到
    [self.navigationBar adjustHeightWhenScrollingEnds];
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
