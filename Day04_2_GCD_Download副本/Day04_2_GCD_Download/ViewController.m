//
//  ViewController.m
//  Day04_2_GCD_Download
//
//  Created by jiyingxin on 15/10/13.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UIButton *downBtn;
@end
@implementation ViewController
- (UIButton *)downBtn {
    if(_downBtn == nil) {
        _downBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _downBtn.backgroundColor=[UIColor lightGrayColor];
        _downBtn.frame = CGRectMake(20, 20, 200, 40);
        [_downBtn addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
        [_downBtn setTitle:@"下载图片" forState:UIControlStateNormal];
        _downBtn.titleLabel.font=[UIFont systemFontOfSize:28];
    }
    return _downBtn;
}
-(void)download{
// NSString->NSURL->NSData->UIImage
    NSString *imagePath=@"http://h.hiphotos.baidu.com/image/w%3D230/sign=9694d806ba0e7bec23da04e21f2fb9fa/9d82d158ccbf6c812f9fe0e1be3eb13533fa400b.jpg";
    NSURL *imageURL=[NSURL URLWithString:imagePath];
//把网络数据下载到NSData中，是耗时操作，时间由网速决定
    dispatch_queue_t globalQueue=dispatch_get_global_queue(0, 0);
//0 是 默认优先级的值
    dispatch_async(globalQueue, ^{
        NSData *data=[NSData dataWithContentsOfURL:imageURL];
        UIImage *img=[UIImage imageWithData:data];
//把图片放入到图片控件中，因为图片控件的更新必须在主线程中执行
//所以我们需要 主队列异步

//    下载图片2, 假设 40行代码
//    下载图片3， 50行代码 ....
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image=img;
        });
    });
}

- (UIImageView *)imageView {
    if(_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
        _imageView.center=self.view.center;
        _imageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.downBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
