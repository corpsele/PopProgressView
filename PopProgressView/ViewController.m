//
//  ViewController.m
//  PopProgressView
//
//  Created by eport on 2019/5/22.
//  Copyright © 2019 eport. All rights reserved.
//

#import "ViewController.h"

#import "PopProgressView.h"

@interface ViewController ()
@property (nonatomic, assign) CGFloat pp;
@property (nonatomic, strong) PopProgressView *progressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)buttonAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    PopProgressView *view = [[PopProgressView alloc] initWithTitle:@"更新提示" withSubTitle:@"监测到新版本的插件,内容如下:#1.iOS接口测试#2.jsdkfjaklsdjfklajklsdjfklasjkdlfjklajkldf#3.kdjfljafijfklafkl;asjdklfjakldsjkl;ajf#4.djfklajdfiejdkjfakldjfk;lajkdl;fjakl;djsfkl;ajdkls;fjkl;asdjfkl;ajdkls;jfkl;asjdf#5.jkldfjajsrij5889tue98rgufiogjfsdjglksdfjkljskdl;fjkl;sdj" withCancelButton:@"打开" withConfirmButton:@"更新"];
    __weak typeof(view) weakView = view;
    [view setPopBlock:^(UIButton * _Nonnull btn) {
        if ([weakView getButtonType] == PopButtonTypeConfirm) {
            [weakSelf startTime];
        }
    }];
    [view setPopFinishBlock:^{

    }];
    [view showView];
    self.progressView = view;
}

- (void)startTime{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:true];
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
}

- (void)timerAction:(NSTimer *)timer{
    self.pp += 0.1;
    [self.progressView setProgress:self.pp];
    if ((int)self.pp == 1) {
        self.pp = 0.0;
        [timer invalidate];
    }
}


@end
