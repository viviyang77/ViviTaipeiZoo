//
//  ZooTableViewController.m
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi. All rights reserved.
//

#import "ZooTableViewController.h"
#import "ZooNavigationBar.h"
#import "ZooTaipeiZooResponse.h"

@interface ZooTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet ZooNavigationBar *navigationBar;
@property (assign, nonatomic) BOOL calculatedNavBarHeight;  // 是否依照不同status bar調整navigation bar高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ZooTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpData];
    [self setUpUI];
    [self setUpString];
}

- (void)setUpData {
    [[ZooDataManager sharedInstance] fetchZooInformationWithOffset:0 limit:3 successBlock:^(ZooTaipeiZooResponse *response) {
        NSLog(@"SUCCEEDED, response: %@", response.dataDict);
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"FAILED, error: %@", error);
    }];
}

- (void)setUpUI {
    
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




#pragma mark -

@end
