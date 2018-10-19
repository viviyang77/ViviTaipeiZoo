//
//  ZooTaipeiZooResponse.h
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi Yang. All rights reserved.
//

#import "ZooBaseResponse.h"
@class ZooResultsModel;

@interface ZooTaipeiZooResponse : ZooBaseResponse

@property (strong, nonatomic) NSArray <ZooResultsModel *> *results;
@property (strong, nonatomic) NSNumber *offset;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSNumber *limit;

@end
