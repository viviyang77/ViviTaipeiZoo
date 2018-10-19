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
    [self fetchZooInformationData];
}

- (void)setUpUI {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

- (void)setUpString {
    
}

- (void)viewWillLayoutSubviews {
    if (!self.calculatedNavBarHeight) {
        self.navigationBarHeightConstraint.constant =
        self.calculatedNavBarHeight = YES;
    }
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
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
    
}

#pragma mark -

- (void)fetchZooInformationData {
    [SVProgressHUD show];
    [self.viewModel fetchZooDataWithCompletion:^(BOOL success, NSString *errorMessage) {
        if (success) {
            [self.tableView reloadData];
        }
        [SVProgressHUD dismiss];
        
        if (errorMessage.length > 0) {
            [SVProgressHUD showErrorWithStatus:errorMessage];
        }
    }];
}

@end
