//
//  ViewController.m
//  waterFlowLayoutDemo
//
//  Created by 61_lsc on 2021/7/5.
//

#import "ViewController.h"
#import "HLLWaterfallLayout.h"
#import "LSCCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDataSource,HLLWaterfallLayoutDelegate>

@property (nonatomic ,strong) NSMutableArray * arrHeight;

@end

@implementation ViewController

static NSString *const identifier = @"waterfall";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建布局
    HLLWaterfallLayout *layout = [[HLLWaterfallLayout alloc] init];
    layout.delegate = self;
    // 创建collecView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    // 注册
    [collectionView registerClass:[LSCCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    
    [self startTime:collectionView];
}

-(void)startTime:(UICollectionView *)collectionView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [collectionView reloadData];
//        [self startTime:collectionView];
    });
}

#pragma mark -- UICollectionViewDataSource --
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 50 + arc4random_uniform(120);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LSCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor orangeColor];
    cell.labelT.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}
#pragma mark -- LFWaterfallLayoutDelegate --
- (CGFloat)waterflowLayout:(HLLWaterfallLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{
    if (index<self.arrHeight.count) {
        return [self.arrHeight[index] floatValue];
    }
    CGFloat h = 50 + arc4random_uniform(120);
    [self.arrHeight addObject:@(h)];
    return h;
}


-(NSMutableArray *)arrHeight{
    if (!_arrHeight) {
        _arrHeight = [NSMutableArray array];
    }
    return _arrHeight;
}



- (CGFloat)columnCountInWaterflowLayout:(HLLWaterfallLayout *)waterflowLayou{
    return 5;
}
//- (CGFloat)columnMarginInWaterflowLayout:(HLLWaterfallLayout *)waterflowLayout{
//    return 20;
//}
//- (CGFloat)rowMarginInWaterflowLayout:(HLLWaterfallLayout *)waterflowLayout{
//    return 20;
//}
//- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(HLLWaterfallLayout *)waterflowLayout{
//    return UIEdgeInsetsMake(20, 20, 20, 20);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
