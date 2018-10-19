//
//  ZooBaseObject.m
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi. All rights reserved.
//

#import "ZooBaseObject.h"

@implementation ZooBaseObject

- (instancetype)initWithDataDict:(NSDictionary *)dataDict {
    self = [super init];
    if (self) {
        _dataDict = dataDict;
    }
    return self;
}

+ (NSArray *)arrayInObjects:(Class)classType byArrayInDictionary:(NSArray<NSDictionary *> *)arrayInDicts {
    if (!arrayInDicts) {
        return @[];
    }
    if (![classType isSubclassOfClass:[ZooBaseObject class]]) {
        return arrayInDicts;
    }
    
    NSMutableArray *arrayInObjects = [NSMutableArray arrayWithCapacity:arrayInDicts.count];
    for (int i = 0; i < arrayInDicts.count; i++) {
        id object = [[classType alloc] initWithDataDict:arrayInDicts[i]];
        [arrayInObjects addObject:object];
    }
    return [arrayInObjects copy];
}

@end
