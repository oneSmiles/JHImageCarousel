//
//  JHImageViewCell.m
//  20161123_lunboqi
//
//  Created by 天叶 on 16/11/23.
//  Copyright © 2016年 天叶. All rights reserved.
//

#import "JHImageViewCell.h"

@interface JHImageViewCell()
/** imgview */
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation JHImageViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setImage:(NSString *)image{
    _image = image;
    self.imageView.image = [UIImage imageNamed:image];
}

-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}
@end
