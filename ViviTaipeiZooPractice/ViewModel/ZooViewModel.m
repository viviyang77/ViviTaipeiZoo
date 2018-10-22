//
//  ZooViewModel.m
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi. All rights reserved.
//

#import "ZooViewModel.h"
#import "ZooTaipeiZooResponse.h"
#import "ZooResultsModel.h"

static NSInteger countPerPage = 30;

@interface ZooViewModel ()

@property (assign, nonatomic) BOOL isFetchingData;
@property (assign, nonatomic) NSInteger maxCount;

@end

@implementation ZooViewModel

- (instancetype)init {
    self = [super init];
    self.resultsArray = [NSMutableArray array];
    self.isFetchingData = NO;
    self.maxCount = NSNotFound;
    return self;
}

- (void)fetchZooDataWithPrecondition:(void(^)(void))preconditionBlock
                          completion:(void(^)(BOOL, NSString *))completionBlock {
    if (self.isFetchingData || (self.maxCount != NSNotFound && self.resultsArray.count >= self.maxCount)) {
        return;
    }
    
    if (preconditionBlock) {
        preconditionBlock();
    }
    
    self.isFetchingData = YES;
    
    [[ZooDataManager sharedInstance] fetchZooInformationWithOffset:self.resultsArray.count limit:countPerPage successBlock:^(ZooTaipeiZooResponse *response) {
//        NSLog(@"SUCCEEDED, response: %@", response.dataDict);
        
        self.isFetchingData = NO;
        self.maxCount = response.count.integerValue;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.resultsArray addObjectsFromArray:response.results];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(YES, nil);
                }
            });
        });
        
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"FAILED, error: %@", error);
        
        self.isFetchingData = NO;
        if (completionBlock) {
            completionBlock(NO, error.localizedDescription);
        }
    }];
}

@end
