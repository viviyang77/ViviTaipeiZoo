//
//  ZooWebManager.m
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi. All rights reserved.
//

#import "ZooWebManager.h"
#import "AFHTTPSessionManager.h"
#import "ZooBaseResponse.h"

@interface ZooWebManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation ZooWebManager

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [[AFHTTPSessionManager alloc] init];
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

        NSMutableSet *newSet = [NSMutableSet set];
        newSet.set = _sessionManager.responseSerializer.acceptableContentTypes;
        [newSet addObject:@"text/html"];
        _sessionManager.responseSerializer.acceptableContentTypes = newSet;
    }
    return _sessionManager;
}

- (void)postWithPath:(NSString *)path
          parameters:(NSDictionary *)parameters
        successBlock:(void (^)(ZooBaseResponse *response))successBlock
        failureBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {
    
    [self.sessionManager POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZooBaseResponse *response = [[ZooBaseResponse alloc] initWithDataDict:maybe(responseObject, NSDictionary)];
        successBlock(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task, error);
    }];
}

- (void)getWithPath:(NSString *)path
         parameters:(NSDictionary *)parameters
       successBlock:(void (^)(ZooBaseResponse *response))successBlock
       failureBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {
    
    [self.sessionManager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZooBaseResponse *response = [[ZooBaseResponse alloc] initWithDataDict:maybe(responseObject, NSDictionary)];
        successBlock(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task, error);
    }];
}

@end
