//
//  ZooTableViewCell.m
//  ViviTaipeiZooPractice
//
//  Created by Vivi on 2018/10/19.
//  Copyright © 2018 Vivi. All rights reserved.
//

#import "ZooTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"
#import "ZooResultsModel.h"

@interface ZooTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *englishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *behaviorLabel;
@property (weak, nonatomic) IBOutlet UILabel *interpretationLabel;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

@end

@implementation ZooTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (![[NSBundle bundleForClass:self.class] pathForResource:NSStringFromClass(self.class) ofType:@"nib"]) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    else {
        self = [[[NSBundle bundleForClass:self.class] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] firstObject];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.rightImageView sd_cancelCurrentImageLoad];
    
    // Reset all views by default
    for (UIView *view in @[self.rightImageView, self.locationLabel, self.nameLabel, self.englishNameLabel, self.noDataLabel]) {
        view.hidden = NO;
    }
    
    for (UIView *view in @[self.behaviorLabel, self.interpretationLabel]) {
        view.hidden = YES;
    }
}

- (void)updateData:(ZooResultsModel *)model {
    if (![model isKindOfClass:ZooResultsModel.class]) {
        return;
    }
    
    self.rightImageView.clipsToBounds = YES;
    self.rightImageView.layer.cornerRadius = 5.0;
    
    // Image view
    if (model.a_Pic01_URL.length > 0) {
        self.rightImageView.hidden = NO;
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:model.a_Pic01_URL] placeholderImage:[UIImage imageNamed:@"zooPlaceholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                [UIView transitionWithView:self.rightImageView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    self.rightImageView.image = image;
                } completion:^(BOOL finished) {
                }];
            }
        }];
    }
    else {
        self.rightImageView.hidden = YES;
    }
    
    // Labels
    [self setText:model.a_Location inLabel:self.locationLabel];
    [self setText:model.a_Name_Ch inLabel:self.nameLabel];
    [self setText:model.a_Name_En inLabel:self.englishNameLabel];
    [self setText:model.a_Behavior inLabel:self.behaviorLabel];
    [self setText:model.a_Interpretation inLabel:self.interpretationLabel];
    self.noDataLabel.hidden = !self.behaviorLabel.hidden || !self.interpretationLabel.hidden;
}

- (void)setText:(NSString *)text inLabel:(UILabel *)label {
    label.text = text;
    label.hidden = text.length == 0;
}

@end
