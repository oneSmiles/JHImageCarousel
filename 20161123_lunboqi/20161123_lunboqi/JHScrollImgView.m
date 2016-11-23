//
//  JHScrollImgView.m
//  20161123_lunboqi
//
//  Created by 天叶 on 16/11/23.
//  Copyright © 2016年 天叶. All rights reserved.
//


/** 轮播间隔时间 */
#define circleTime 2

#import "JHScrollImgView.h"
#import "JHImageViewCell.h"

@interface JHScrollImgView ()<UICollectionViewDelegate,UICollectionViewDataSource>
/** 轮播 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 翻页圆点控件 */
@property (nonatomic, strong) UIPageControl *pageControl;
/** 记录下标,仅用来翻页计算 */
@property (nonatomic, assign) NSInteger currentIndex;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;

/** 标记当前正在所显示的页面,和currentIndex有差别,要取到当前显示的页面, 需取该值 */
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation JHScrollImgView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    // 启动定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:circleTime / 2 target:self selector:@selector(repeatAction) userInfo:nil repeats:YES];
}

-(void)repeatAction{
    // 默认在中间页, 滚动到后面的那页
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    // pageControl刷新位置
    NSInteger offset = self.collectionView.contentOffset.x / self.frame.size.width - 1;
    self.pageIndex = (self.currentIndex + offset + self.imgArray.count) % self.imgArray.count + 1;
    if (self.pageIndex >= self.imgArray.count) {
        self.pageIndex = 0;//处理最后点
    }
    self.pageControl.currentPage = self.pageIndex;
    // 翻页结束后瞬间切回中间页
    [self scrollViewDidEndDecelerating:self.collectionView];
}

#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;//无限翻页,只有3页,在翻到第三页或者第一页时瞬间切回第二页,给人视觉上认为是无限翻页
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //如果更换cell, 切记将collectionView懒加载中的JHImageViewCell替换成你的cell,否则会崩溃
    JHImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHImageViewCell" forIndexPath:indexPath];
    NSInteger index = (indexPath.item - 1 + self.imgArray.count + self.currentIndex) % self.imgArray.count;
    if (self.imgArray.count>0) {
       cell.image = self.imgArray[index];
    }
    return cell;
}

/**
 点击图片代理

 @param collectionView collectionView
 @param indexPath indexpath
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(imageClick:)]) {
        [self.delegate imageClick:self.pageIndex];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger offset = scrollView.contentOffset.x / self.frame.size.width - 1;
    //如果offset是0 代表显示当前自己
    if(offset == 0) return;
    //这个值也不能超过 images.count
    self.currentIndex = (self.currentIndex + offset + self.imgArray.count) % self.imgArray.count;
    self.pageIndex = self.currentIndex;
    self.pageControl.currentPage = self.currentIndex;
    /*
     问题:界面在切换的时候会发生界面显示不正确.
     缘由:由于scrollViewDidEndDecelerating是在动画结束之后调用,动画是在后台执行的,这个方法就是在后台调用的.
     界面跳转的方法需要在主线程进行调用,那么我们就回到主线程来进行调用
     */
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    [UIView setAnimationsEnabled:NO];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    //开始全局动画
    [UIView setAnimationsEnabled:YES];
}


-(void)setImgArray:(NSArray *)imgArray{
    _imgArray = imgArray;
    self.pageControl.numberOfPages = imgArray.count;
    // 设置滚动范围
    self.collectionView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    // 默认显示第一页
    self.currentIndex = 0;
    // 前面还有一页, 所以默认在第二页
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
}

-(void)dealloc{
    // 停止定时器
    [self.timer invalidate];
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer=nil;
    }
}

#pragma mark - getter / setter

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        // 定义大小
        layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        // 设置最小行间距
        layout.minimumLineSpacing = 0;
        // 设置垂直间距
        layout.minimumInteritemSpacing = 0;
        // 设置滚动方向（默认垂直滚动）
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[JHImageViewCell class] forCellWithReuseIdentifier:@"JHImageViewCell"];
    }
    return _collectionView;
}

-(UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(20, self.frame.size.height-25, self.frame.size.width-40, 25)];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor blueColor];
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}



@end
