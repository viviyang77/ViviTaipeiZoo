//
//  ZooViewModel.h
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZooResultsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZooViewModel : NSObject

@property (strong, nonatomic) NSMutableArray <ZooResultsModel *> *resultsArray;

- (void)fetchZooDataWithCompletion:(void(^)(BOOL success, NSString *errorMessage))completionBlock;

@end

NS_ASSUME_NONNULL_END
