//
//  PopProgressView.m
//  PopProgressView
//
//  Created by eport on 2019/5/22.
//  Copyright © 2019 eport. All rights reserved.
//


///进度颜色
#define KProgressColor [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1]
///视图的字体
#define KPopProgressViewFont [UIFont systemFontOfSize: 16.0f]
///RGB2HEX颜色
#define ssRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define MAINSCREEN [UIScreen mainScreen]


#import "PopProgressView.h"

@interface PopProgressView(){
    /**
     正文动态高
     */
    CGFloat dynamicSubTitleHeight;
}


/**
 背景视图
 */
@property (nonatomic, strong) UIView *viewBackground;

/**
 弹出视图
 */
@property (nonatomic, strong) UIView *viewPop;


/**
 横线视图
 */
@property (nonatomic, strong) UIView *viewHorizontalLine;

/**
 竖线视图
 */
@property (nonatomic, strong) UIView *viewVerticalLine;

/**
 取消按钮
 */
@property (nonatomic, strong) UIButton *btnCancel;

/**
 确定按钮
 */
@property (nonatomic, strong) UIButton *btnConfirm;

/**
 标题
 */
@property (nonatomic, strong) UILabel *lblTitle;

/**
 正文
 */
@property (nonatomic, strong) UILabel *lblSubTitle;

/**
 标题文字
 */
@property (nonatomic, strong) NSString *strTitle;

/**
 正文文字
 */
@property (nonatomic, strong) NSString *strSubTitle;

/**
 取消按钮文字
 */
@property (nonatomic, strong) NSString *strCancel;

/**
 确认按钮文字
 */
@property (nonatomic, strong) NSString *strConfirm;

/**
 进度条视图
 */
@property (nonatomic, strong) UIProgressView *viewProgress;

/**
 按钮类型
 */
@property (nonatomic, assign) PopButtonType buttonType;

@end

@implementation PopProgressView


/// MARK: -- 初始化类
- (instancetype)initWithTitle:(NSString *)title withSubTitle:(NSString *)subTitle withCancelButton:(NSString *)cancelButton withConfirmButton:(NSString *)confirmButton{
    self = [super init];
    if (self) {
        self.strTitle = title;
        self.strSubTitle = subTitle;
        self.strCancel = cancelButton;
        self.strConfirm = confirmButton;
        
        [self setupView];
    }
    return self;
}

/// MARK: -- 初始化视图
- (void)setupView{
    [self configView];

    [self addSubview:[self setupBackgroundView]];
    [self addSubview:[self setupPopView]];
    [_viewPop addSubview:[self setupTitleView]];
    [_viewPop addSubview:[self setupSubTitleView]];
    [_viewPop addSubview:[self setupProgressView]];
    [_viewPop addSubview:[self setupHorizontalLine]];
    
    [self setupButtons];
    
    [self countSize];
    
//    self.progress = 0.2f;
}

- (void)configView{
    self.backgroundColor = [UIColor clearColor];
    self.frame = MAINSCREEN.bounds;
}

/// MARK: -- 配置弹出视图
- (UIView *)setupPopView{
    _viewPop = [[UIView alloc] initWithFrame:CGRectMake(70.0f, 0.0f, self.bounds.size.width - 70.0f, 0.0f)];
    _viewPop.layer.masksToBounds = true;
    [_viewPop.layer setCornerRadius:8.0];
    [_viewPop.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_viewPop.layer setBorderWidth:1.0];
    _viewPop.backgroundColor = [UIColor whiteColor];
    return _viewPop;
}
/// MARK: -- 配置背景视图
- (UIView *)setupBackgroundView{
    _viewBackground = [[UIView alloc] initWithFrame:MAINSCREEN.bounds];
    _viewBackground.backgroundColor = [UIColor blackColor];
    _viewBackground.alpha = 0.3f;
    return _viewBackground;
}

/// MARK: -- 配置标题视图
- (UIView *)setupTitleView{
    //配置标题
    //计算文字大小
    CGSize titleSize = [_strTitle sizeWithAttributes:@{NSFontAttributeName:KPopProgressViewFont}];
    _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(_viewPop.frame.size.width / 2 - titleSize.width + 7.5f, 20.0f, titleSize.width, 30.0f)];
    [_lblTitle setText:_strTitle];
    [_lblTitle setTextColor:[UIColor blackColor]];
    [_lblTitle setFont:KPopProgressViewFont];
    return _lblTitle;
}

/// MARK: -- 配置正文视图
- (UIView *)setupSubTitleView{
    //正文替换字符
    _strSubTitle = [_strSubTitle stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
    //计算文字大小
//    CGSize subTitleSize = [_strSubTitle sizeWithAttributes:@{NSFontAttributeName:KPopProgressViewFont}];
    CGSize subTitleSize = [_strSubTitle boundingRectWithSize:CGSizeMake(_viewPop.frame.size.width - 60.0f, 500.0f) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KPopProgressViewFont} context:nil].size;
    _lblSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, _lblTitle.frame.origin.y + _lblTitle.frame.size.height + 5.0f, _viewPop.frame.size.width - 60.0f, subTitleSize.height + 30.0f)];
    [_lblSubTitle setText:_strSubTitle];
    [_lblSubTitle setTextColor:[UIColor blackColor]];
    [_lblSubTitle setFont:KPopProgressViewFont];
    _lblSubTitle.numberOfLines = 0;
    return _lblSubTitle;
}

/// MARK: -- 配置进度视图
- (UIView *)setupProgressView{
    //配置进度视图
    _viewProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(5.0f, _lblSubTitle.frame.origin.y + _lblSubTitle.frame.size.height + 5.0f, _viewPop.frame.size.width - 60.0f, 20.0f)];
    _viewProgress.layer.masksToBounds = true;
    _viewProgress.layer.cornerRadius = 8.0f;
//    [_viewProgress setBackgroundColor:[UIColor whiteColor]];
//    [_viewProgress setTintColor:[UIColor whiteColor]];
//    [_viewProgress setBackgroundColor:[UIColor whiteColor]];
    _viewProgress.contentMode = UIViewContentModeScaleAspectFill;
    [_viewProgress setTrackTintColor:[UIColor whiteColor]];
    [_viewProgress setProgressTintColor:KProgressColor];
    _viewProgress.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    
    return _viewProgress;
}

/// MARK: -- 配置横线视图
- (UIView *)setupHorizontalLine{
    _viewHorizontalLine = [[UIView alloc] initWithFrame:CGRectMake(2.0f, _viewProgress.frame.origin.y + _viewProgress.frame.size.height + 15.0f, _viewPop.frame.size.width - 2.0f * 2, 1.0f)];
    [_viewHorizontalLine setBackgroundColor:[UIColor blackColor]];
    return _viewHorizontalLine;
}

/// MARK: -- 配置竖线视图
- (UIView *)setupVerticalLine{
    _viewVerticalLine = [[UIView alloc] initWithFrame:CGRectMake(_viewPop.frame.size.width / 2 - 22.0f, _viewHorizontalLine.frame.origin.y + _viewHorizontalLine.frame.size.height, 1.0f, 75.0f)];
    [_viewVerticalLine setBackgroundColor:[UIColor blackColor]];
    return _viewVerticalLine;
}

/// MARK: -- 配置打开按钮
- (UIButton *)setupCancelBtn{
    _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, _viewPop.frame.size.height - 75.0f, 180.0f, 80.0f)];
    [_btnCancel setTitle:_strCancel forState:UIControlStateNormal];
    [_btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnCancel.tag = 1210;
    [_btnCancel addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return _btnCancel;
}

/// MARK: -- 配置更新按钮
- (UIButton *)setupConfirmBtn{
    _btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, _viewPop.frame.size.height - 75.0f, 180.0f, 80.0f)];
    [_btnConfirm setTitle:_strConfirm forState:UIControlStateNormal];
    [_btnConfirm setTitleColor:ssRGBHex(0x5076AF) forState:UIControlStateNormal];
    _btnConfirm.tag = 1211;
    [_btnConfirm addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return _btnConfirm;
}

/// MARK: -- 配置按钮
- (void)setupButtons{
    if (_strCancel && _strCancel.length > 0) {
        [_viewPop addSubview:[self setupCancelBtn]];
        _btnCancel.frame = CGRectMake(0.0f, _viewHorizontalLine.frame.origin.y + _viewHorizontalLine.frame.size.height, _viewPop.frame.size.width / 2 - 22.0f, 60.0f);
    }
    
    if (_strConfirm && _strConfirm.length > 0) {
        if (_strCancel && _strCancel.length > 0) {
            [_viewPop addSubview:[self setupVerticalLine]];
            [_viewPop addSubview:[self setupConfirmBtn]];
            _btnConfirm.frame = CGRectMake(_btnCancel.bounds.size.width + 1.0f, _viewHorizontalLine.frame.origin.y + _viewHorizontalLine.frame.size.height, _viewPop.frame.size.width - _btnCancel.bounds.size.width - 50.0f, 60.0f);
        }else{
            [_viewPop addSubview:[self setupConfirmBtn]];
            _btnConfirm.frame = CGRectMake(0.0f, _viewHorizontalLine.frame.origin.y + _viewHorizontalLine.frame.size.height, _viewPop.frame.size.width - 50.0f, 60.0f);
        }
    }
}

/// MARK: -- 计算视图大小
- (void)countSize{
    CGFloat titleHeight = _lblTitle.bounds.origin.y + _lblTitle.bounds.size.height + 20.0f;
    CGFloat subTitleHeight = _lblSubTitle.bounds.origin.y + _lblSubTitle.bounds.size.height + 5.0;
    CGFloat progressHeight = 20.0f;
    CGFloat hLineHeight = 1.0f;
    CGFloat btnHeight = 60.0f;
    CGFloat total = titleHeight + subTitleHeight + progressHeight + hLineHeight + btnHeight;
    _viewPop.frame = CGRectMake(60.0f, MAINSCREEN.bounds.size.height / 2 - total / 2, self.bounds.size.width - 60.0f * 2, total);
}

- (void)showView{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    [window makeKeyAndVisible];
    
    [self popAnimation];
}

/// MARK: -- 弹出动画
- (void)popAnimation{
    //Block内存
    __block UIView *weakPopView = _viewPop;
    //动画
    _viewPop.transform = CGAffineTransformMakeScale(0.4, 0.4);
    
    [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 options:UIViewAnimationOptionTransitionNone animations:^{
        weakPopView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}

/// MARK: -- 关闭动画
- (void)closeAnimation{
    //Block内存
    __block UIView *weakPopView = _viewPop;
    __block UIView *weakSelf = self;
    //动画
    [UIView animateWithDuration:0.1 delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 options:UIViewAnimationOptionTransitionNone animations:^{
        weakPopView.transform = CGAffineTransformMakeScale(1.15, 1.15);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            
            weakPopView.transform = CGAffineTransformMakeScale(0.75, 0.75);
            
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    }];
}

/// MARK: -- 设置进度
- (void)setProgress:(CGFloat)progress{
    if ((int)progress == 1) {
        _btnConfirm.userInteractionEnabled = true;
        if (self.popFinishBlock) {
            [self closeAnimation];
            self.popFinishBlock();
        }
        return;
    }
    [_viewProgress setProgress:progress animated:true];
}

/// MARK: -- 按钮事件
- (void)btnAction:(UIButton *)btn{
    if (btn.tag == 1210) {
        self.buttonType = PopButtonTypeCancel;
      [self closeAnimation];
    }else{
        self.buttonType = PopButtonTypeConfirm;
        btn.userInteractionEnabled = false;
    }
    if (self.popBlock) {
        self.popBlock(btn);
    }
}

- (PopButtonType)getButtonType{
    return self.buttonType;
}

@end
