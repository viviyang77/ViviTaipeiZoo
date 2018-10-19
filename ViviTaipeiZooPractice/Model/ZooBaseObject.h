//
//  ZooBaseObject.h
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZooBaseObject : NSObject

@property (strong, nonatomic) NSDictionary *dataDict;

- (instancetype)initWithDataDict:(NSDictionary *)dataDict;
+ (NSArray *)arrayInObjects:(Class)classType byArrayInDictionary:(NSArray<NSDictionary *> *)arrayInDicts;

@end

NS_ASSUME_NONNULL_END
