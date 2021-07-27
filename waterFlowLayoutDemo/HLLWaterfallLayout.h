//
//  HLLWaterfallLayout.h
//  waterFlowLayoutDemo
//
//  Created by 61_lsc on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLLWaterfallLayout;
/**
 * 代理传值
 */
@protocol HLLWaterfallLayoutDelegate <NSObject>

@required
- (CGFloat)waterflowLayout:(HLLWaterfallLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
/**
 * 设置瀑布流的列数
 */
- (CGFloat)columnCountInWaterflowLayout:(HLLWaterfallLayout *)waterflowLayout;
/**
 * 设置瀑布流列的间距
 */
- (CGFloat)columnMarginInWaterflowLayout:(HLLWaterfallLayout *)waterflowLayout;
/**
 * 设置瀑布流行的间距
 */
- (CGFloat)rowMarginInWaterflowLayout:(HLLWaterfallLayout *)waterflowLayout;
/**
 * 设置瀑布流边缘（四周）的间隙
 */
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(HLLWaterfallLayout *)waterflowLayout;
@end

@interface HLLWaterfallLayout : UICollectionViewLayout

@property (nonatomic , weak) id<HLLWaterfallLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
