//
//  HLLWaterFlowLayout.h
//  waterFlowLayoutDemo
//
//  Created by 61_lsc on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLLWaterFlowLayout;
@protocol HLLWaterFlowLayoutDelegate <NSObject>

//使用delegate取得每一个Cell的高度
- (CGFloat)waterFlowLayout:(HLLWaterFlowLayout *)layout heightForCellAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface HLLWaterFlowLayout : UICollectionViewLayout

//声明协议
@property (nonatomic, weak) id <HLLWaterFlowLayoutDelegate> delegate;
//确定列数
@property (nonatomic, assign) NSInteger colum;
//确定内边距
@property (nonatomic, assign) UIEdgeInsets insetSpace;
//确定每个cell之间的距离
@property (nonatomic, assign) NSInteger distance;

@end

NS_ASSUME_NONNULL_END
