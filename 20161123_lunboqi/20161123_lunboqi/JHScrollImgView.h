//
//  JHScrollImgView.h
//  20161123_lunboqi
//
//  Created by 天叶 on 16/11/23.
//  Copyright © 2016年 天叶. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JHScrollImgViewDelegate <NSObject>

@optional
-(void)imageClick:(NSInteger)index;

@end

@interface JHScrollImgView : UIView

/** 几个image */
@property (nonatomic, strong) NSArray *imgArray;


/** 代理 */
@property (nonatomic, weak) id<JHScrollImgViewDelegate> delegate;
@end
