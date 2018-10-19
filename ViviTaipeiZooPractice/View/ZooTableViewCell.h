//
//  ZooTableViewCell.h
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZooResultsModel;

@interface ZooTableViewCell : UITableViewCell

- (void)updateData:(ZooResultsModel *)model;

@end
