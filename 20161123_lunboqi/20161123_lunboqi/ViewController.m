//
//  ViewController.m
//  20161123_lunboqi
//
//  Created by 天叶 on 16/11/23.
//  Copyright © 2016年 天叶. All rights reserved.
//

#import "ViewController.h"
#import "JHScrollImgView.h"

@interface ViewController ()<JHScrollImgViewDelegate>
@property (nonatomic, strong) NSArray *images;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    JHScrollImgView *scrollView = [[JHScrollImgView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    scrollView.delegate = self;
    scrollView.imgArray = self.images;
    [self.view addSubview:scrollView];
    
}


-(void)imageClick:(NSInteger)index{
    NSLog(@"点击了第几张图片%ld == %@",index,self.images[index]);
}

#pragma mark -- 懒加载
- (NSArray *)images{
    if(_images == nil){
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 0; i < 9; i++) {
            [temp addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _images = temp;
    }
    return _images;
}

@end
