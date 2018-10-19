//
//  ZooTaipeiZooResponse.m
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi Yang. All rights reserved.
//

#import "ZooTaipeiZooResponse.h"
#import "ZooResultsModel.h"

@implementation ZooTaipeiZooResponse

- (NSArray <ZooResultsModel *> *)results {
    if (!_results) {
        _results = [ZooBaseObject arrayInObjects:ZooResultsModel.class byArrayInDictionary:maybe(self.dataDict[@"results"], NSArray)];
    }
    return _results;
}

- (NSNumber *)offset {
    if (!_offset) {
        _offset = maybe(self.dataDict[@"offset"], NSNumber);
    }
    return _offset;
}

- (NSNumber *)count {
    if (!_count) {
        _count = maybe(self.dataDict[@"count"], NSNumber);
    }
    return _count;
}

- (NSString *)sort {
    if (!_sort) {
        _sort = nonEmptyString(self.dataDict[@"sort"]);
    }
    return _sort;
}

- (NSNumber *)limit {
    if (!_limit) {
        _limit = maybe(self.dataDict[@"limit"], NSNumber);
    }
    return _limit;
}

@end
