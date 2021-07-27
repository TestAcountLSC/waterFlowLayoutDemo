//
//  LSCCollectionViewCell.m
//  waterFlowLayoutDemo
//
//  Created by 61_lsc on 2021/7/8.
//

#import "LSCCollectionViewCell.h"

@implementation LSCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, 100, 30);
        label.textColor = [UIColor blackColor];
        [self.contentView addSubview:label];
        self.labelT = label;
    }
    return self;
}

@end
