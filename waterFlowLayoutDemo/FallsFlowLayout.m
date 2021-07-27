//
//  FallsFlowLayout.m
//  HQCollectionViewDemo
//
//  Created by 61_lsc on 2021/7/13.
//  Copyright © 2021 君凯商联网. All rights reserved.
//

#import "FallsFlowLayout.h"

@interface FallsFlowLayout()

@property (nonatomic, strong) NSMutableArray *itemAttributes; // 存放每个cell的布局属性
@property (nonatomic, strong) NSMutableArray *columnsHeightsOfSection; // 每个Section的每一列的高度，二维数组
@property (nonatomic, assign) NSInteger stickHeight;//悬停Header的高度

@end

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation FallsFlowLayout

#pragma mark- 懒加载
- (NSMutableArray *)columnsHeightsOfSection {
    if (!_columnsHeightsOfSection) {
        _columnsHeightsOfSection = [NSMutableArray array];
    }
    return _columnsHeightsOfSection;
}

- (NSMutableArray *)itemAttributes {
    if (!_itemAttributes) {
        _itemAttributes= [NSMutableArray array];
    }
    return _itemAttributes;
}

#pragma mark- 初始化方法
- (instancetype)init {
    if(self= [super init]) {
        // 初始化默认值
        self.numberOfColumns = 2;//默认列数为2
        self.columnGap=10;//默认列间距为10
        self.rowGap=10;//默认行间距为10
        self.insets = UIEdgeInsetsMake(10, 10, 10, 10);//默认UICollectionView的内边距为10
        self.stickHeight=44;//悬停的Header高度
        self.sectionCount=2;//默认为2
    }
    return self;
}

#pragma mark- get方法

/// 获取单元格宽度
- (CGFloat)itemWidth {
    //（ collectionView的宽度 - 列间距*列数 ) / 列数
    return (self.collectionView.frame.size.width - (self.numberOfColumns + 1)*self.columnGap) / self.numberOfColumns;
}

/// 获取某个section的最短列的编号
/// @param section 分区
- (NSUInteger)minIndexOfSection:(NSUInteger)section {
    NSInteger minIndex =0;
    CGFloat minHeight =MAXFLOAT;
    for(NSInteger i =0; i <self.numberOfColumns; i ++) {
        // 取出某一列的高度与其他的比较，求得高度最短的列的 列号
        CGFloat currentHeight = [self.columnsHeightsOfSection[section][i]floatValue];
        if(currentHeight < minHeight) {
            minHeight = currentHeight;
            minIndex = i;
        }
    }
    return minIndex;
}

/// 获取某个section的最短列的编号
/// @param section 分区
- (NSUInteger)maxIndexOfSection:(NSUInteger)section {
    NSInteger maxIndex =0;
    CGFloat maxHeight =0;
    for(NSInteger i =0; i <self.numberOfColumns; i ++) {
        CGFloat currentHeight = [self.columnsHeightsOfSection[section][i]floatValue];
        if(currentHeight > maxHeight) {
            maxHeight = currentHeight;
            maxIndex = i;
        }
    }
    return maxIndex;
}

/// 获取某个section的最短高度
/// @param section 分区
- (CGFloat)minHeightOfSection:(NSUInteger)section {
    // 该section 最短列的列号
    NSUInteger minIndex = [self minIndexOfSection:section];

    return[self.columnsHeightsOfSection[section][minIndex]floatValue];
}

/// 获取某个section的最大高度
/// @param section 分区
- (CGFloat)maxHeightOfSection:(NSUInteger)section {
    NSUInteger maxIndex = [self maxIndexOfSection:section];

    return[self.columnsHeightsOfSection[section][maxIndex]floatValue];
}

#pragma mark- 系统内部方法
/// 重写父类布局
- (void)prepareLayout {
    [super prepareLayout];

    // 重置每一个Section的每一列的最大Y值为Header高度
    [self.columnsHeightsOfSection removeAllObjects];
    for(int i =0;i <self.sectionCount;i++){
        NSMutableArray*columnsHeights = [NSMutableArray array];
        for(int j =0;j <self.numberOfColumns;j++){
            // 每个Section的Header高度,我的Header高度为44
            [columnsHeights addObject:@(44)];
        }
        [self.columnsHeightsOfSection addObject:columnsHeights];
    }

    // 计算所有cell的布局属性，包括HeaderView的,先清空
    [self.itemAttributes removeAllObjects];

    // Header
    NSMutableArray<UICollectionViewLayoutAttributes *> *layoutHeader = [NSMutableArray arrayWithCapacity:self.sectionCount];

    // 跑这个Section循环是为了实现多Section
    for(int section =0;section <self.sectionCount;section++)
    {
        // 头部视图
        layoutHeader[section] = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathWithIndex:section]];

        // Header的y坐标为 前面Section的最大高度之和
        int y =0;
        for(int i =0;i < section;i++)
            y += [self maxHeightOfSection:i];

        // 我的HeaderView的高度为44
        layoutHeader[section].frame=CGRectMake(0,y,kScreenWidth,44);
        // 将Header的属性添加到数组
        [self.itemAttributes addObject:layoutHeader[section]];

        // 计算所有cell的布局属性,看好下面的section
        NSUInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for(NSUInteger i =0; i < itemCount; ++i) {
            NSIndexPath*indexPath = [NSIndexPath indexPathForItem:i inSection:section];
            [self setItemFrame:indexPath];
        }
    }
}

/// 设置每一个attrs的frame，并加入数组中
/// @param indexPath 第几个item
- (void)setItemFrame:(NSIndexPath*)indexPath {
    /**
     * 注：1.cell的宽度和高度算起来比较简单 : 宽度固定(itemWidth已经算好)，高度由外部传进来
     *    2.cell的x : minIndex最短列作为当前列。
     *    3.cell的y : 把前面所有Section的最大高度求和 + 该Section的最短列高度
     */

    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    // cell的宽度和高度
    CGFloat w =self.itemWidth;
    CGFloat h = [self.itemHeights[indexPath.item]floatValue];

    // 最短列编号
    NSUInteger minIndex = [self minIndexOfSection:indexPath.section];
    CGFloat x =self.insets.left+ minIndex * (w +self.columnGap);

    // 前面几个section的最大高度之和 + 该section的最短列高度
    CGFloat topSectionHeight =0;
    CGFloat minHeight =0;
    for(int i =0;i < indexPath.section;i++)
        topSectionHeight += [self maxHeightOfSection:i];

    // 加上该section的最短列高度
    minHeight += [self minHeightOfSection:indexPath.section];
    CGFloat y =topSectionHeight + minHeight +self.rowGap;

    attrs.frame=CGRectMake(x, y, w, h);

    // 更新该Section的高度
    self.columnsHeightsOfSection[indexPath.section][minIndex] =@(h + minHeight +self.rowGap);
    [self.itemAttributes addObject:attrs];
}

/// 返回collectionView的尺寸
- (CGSize)collectionViewContentSize {
    CGFloat maxHeight =0;
    for(int i =0;i <self.sectionCount; i++){
        maxHeight += [self maxHeightOfSection:i];
    }
    return CGSizeMake(self.collectionView.frame.size.width, maxHeight);
}

/// 所有元素（比如cell、补充控件、装饰控件）的布局属性
/// @param rect 尺寸
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    [self sectionHeaderStickCounter];//Header停留
    return self.itemAttributes;
}

#pragma mark- Header 停留
/// Header停留
- (void)sectionHeaderStickCounter
{
    for (UICollectionViewLayoutAttributes *layoutAttributes in self.itemAttributes) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            CGPoint origin = layoutAttributes.frame.origin;

            if(layoutAttributes.indexPath.section==0){
                // 只要往上一滑动，就将Header的y修改为collectionView.contentOffset.y，至于为什么是这个数，可以打个Log输出看看结果

                // self.collectionView.contentOffset.y 是相对于CollectionView的content的相对y移动
                if (self.collectionView.contentOffset.y >= 0)
                    origin.y=self.collectionView.contentOffset.y;

                // 如果滑动到该下一个Section的Header上来了，则固定第一个的Header的y值
                if(self.collectionView.contentOffset.y>= [self maxHeightOfSection:0] -self.stickHeight)
                    origin.y= [self maxHeightOfSection:0] -self.stickHeight;
            }else{
                // 这是默认两个Section的情况，如果有更多种情况，自己计算一下，加几个else if就好了
                if(self.collectionView.contentOffset.y>= [self maxHeightOfSection:0])
                    origin.y=self.collectionView.contentOffset.y;
            }

            CGFloat width = layoutAttributes.frame.size.width;
            layoutAttributes.zIndex = 2048;//设置一个比cell的zIndex大的值，让他浮于其他Cell之上
            layoutAttributes.frame= (CGRect){
                .origin= origin,
                .size=CGSizeMake(width, layoutAttributes.frame.size.height)
            };
        }
    }
}

/// 不设置这里看不到悬停
/// @param newBounds description
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
