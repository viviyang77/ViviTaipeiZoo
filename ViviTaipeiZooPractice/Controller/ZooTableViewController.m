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

@end

@implementation ZooTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpData];
    [self setUpUI];
    [self setUpString];
}

- (void)setUpData {
    self.viewModel = [ZooViewModel new];
    [self fetchZooInformationDataIfInitial:YES];
}

- (void)setUpUI {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

- (void)setUpString {
    //TODO: Navigation bar title & text
}

- (void)viewWillLayoutSubviews {
    if (!self.calculatedNavBarHeight) {
        //TODO: iPhone X navigation bar
//        self.navigationBarHeightConstraint.constant =
        self.calculatedNavBarHeight = YES;
    }
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //TODO: Navigation bar scrolling
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
