//
//  ZooDataManager.m
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi. All rights reserved.
//

#import "ZooDataManager.h"
#import "ZooWebManager.h"
#import "ZooTaipeiZooResponse.h"

static NSString *taipeiZooURL = @"https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613";

@interface ZooDataManager ()

@property (strong, nonatomic) ZooWebManager *webManager;
@property (strong, nonatomic) NSString *baseURL;

@end

@implementation ZooDataManager

+ (ZooDataManager *)sharedInstance {
    static ZooDataManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ZooDataManager alloc] init];
    });
    return sharedManager;
}

- (ZooWebManager *)webManager {
    if (!_webManager) {
        _webManager = [ZooWebManager new];
    }
    return _webManager;
}

- (void)fetchZooInformationWithOffset:(NSInteger)offset
                                limit:(NSInteger)limit
                         successBlock:(void(^)(ZooTaipeiZooResponse *))successBlock
                         failureBlock:(void(^)(NSURLSessionDataTask *, NSError *))failureBlock {
    
    NSDictionary *params = @{@"limit":@(limit), @"offset":@(offset)};
    [self.webManager getWithPath:taipeiZooURL parameters:params successBlock:^(ZooBaseResponse * _Nonnull response) {
        ZooTaipeiZooResponse *zooResponse = [[ZooTaipeiZooResponse alloc] initWithDataDict:response.dataDict];
        successBlock(zooResponse);
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        failureBlock(task, error);
    }];
}

@end
