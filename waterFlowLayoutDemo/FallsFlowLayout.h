//
//  FallsFlowLayout.h
//  HQCollectionViewDemo
//
//  Created by 61_lsc on 2021/7/13.
//  Copyright © 2021 君凯商联网. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FallsFlowLayout : UICollectionViewLayout

@property (nonatomic, assign, readonly) CGFloat itemWidth;//单元格宽度
@property (nonatomic, assign) NSInteger numberOfColumns;//列数：默认为2
@property (nonatomic, assign) UIEdgeInsets insets;//内边距 : 每一列之间的间距 (top, left, bottom, right)默认为{10, 10, 10, 10};
@property (nonatomic, assign) CGFloat rowGap;//每一行之间的间距 : 默认为10
@property (nonatomic, assign) CGFloat columnGap;//每一列之间的间距 : 默认为10
@property (nonatomic, strong) NSMutableArray *itemHeights;//高度数组 : 存储所有item的高度
@property (nonatomic, assign) NSUInteger sectionCount;// section数目，默认为2

@end

NS_ASSUME_NONNULL_END
