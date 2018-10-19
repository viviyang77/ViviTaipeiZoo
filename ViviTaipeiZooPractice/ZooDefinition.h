//
//  ZooDefinition.h
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi. All rights reserved.
//

#ifndef ZooDefinition_h
#define ZooDefinition_h

#define nonEmptyString(object) ((NSString *)([object isKindOfClass:[NSString class]] ? object : @""))
#define weakSelfMake(weakSelf) __weak __typeof(&*self)weakSelf = self;
#define notNull(obj) (obj && (![obj isEqual:[NSNull null]]) && (![obj isEqual:@"<null>"]))
#define maybe(object, classType) ((classType *)([object isKindOfClass:[classType class]] ? object : nil))

#endif /* ZooDefinition_h */
