//
//  ZooDataManager.h
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZooTaipeiZooResponse;

@interface ZooDataManager : NSObject

+ (ZooDataManager *)sharedInstance;

- (void)fetchZooInformationWithOffset:(NSInteger)offset
                                limit:(NSInteger)limit
                         successBlock:(void(^)(ZooTaipeiZooResponse *response))successBlock
                         failureBlock:(void(^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

@end
