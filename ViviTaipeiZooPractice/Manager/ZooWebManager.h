//
//  ZooWebManager.h
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;
@class ZooBaseResponse;

NS_ASSUME_NONNULL_BEGIN

@interface ZooWebManager : NSObject

- (void)postWithPath:(NSString *)path
          parameters:(NSDictionary *)parameters
        successBlock:(void (^)(ZooBaseResponse *response))successBlock
        failureBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

- (void)getWithPath:(NSString *)path
         parameters:(NSDictionary *)parameters
       successBlock:(void (^)(ZooBaseResponse *response))successBlock
       failureBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

@end

NS_ASSUME_NONNULL_END
