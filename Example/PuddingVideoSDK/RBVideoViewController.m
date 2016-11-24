//
//  RBVideoViewController.m
//  PuddingVideoSDK
//
//  Created by Zhi Kuiyu on 2016/11/24.
//  Copyright © 2016年 zhiyu330691038. All rights reserved.
//

#import "RBVideoViewController.h"
#import "RBLiveVideoClient.h"
#import "UIViewController+RBtip.h"

#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s\n", __TIME__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

extern RBLiveVideoClient *videoClient;

@interface RBVideoViewController ()<RBLiveVideoDelegate>{
    BOOL isConnect;
}
@property (weak, nonatomic) IBOutlet UIView *videoSpaceView;
@property (weak, nonatomic) IBOutlet UILabel *deviceid;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIButton *reconnectBtn;

@end

@implementation RBVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    float width = [UIScreen mainScreen].bounds.size.width;

    UIView * vi  =[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 64)];
    vi.backgroundColor = [UIColor colorWithRed:97/255.0 green:212/255.0 blue:255/255.0 alpha:1];
    [self.view addSubview:vi];
    
    
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.text = @"视频连接";
    lab.center = CGPointMake(width*0.5, 20+lab.frame.size.height*0.5);
    [vi addSubview:lab];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 20, 60, 44);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [vi addSubview:btn];
    [btn addTarget:self action:@selector(navBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _deviceid.text = self.device_id;
    [_loadingView startAnimating];
    videoClient.delegate = self;

    [videoClient call:self.device_id];

}

- (void)navBackBtnClick:(id)sender{
    [self disConnectVideo:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)muteAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    videoClient.localAudioEnable = sender.selected;
}
- (IBAction)disConnectVideo:(id)sender {
    [videoClient hangup];
    isConnect = NO;
    self.loadingView.hidden = YES;
    self.reconnectBtn.hidden = NO;
}

- (IBAction)recoredVideoAction:(UIButton *)sender {
    if(!isConnect) return;
    
    sender.selected = !sender.selected;
    if(sender.selected){
        [videoClient recordVideo];
    }else{
        [videoClient stopRecord];
    }
}

- (IBAction)screenShotAction:(id)sender {
    if(!isConnect) return;
    [videoClient captureImage];

}
- (IBAction)reconnectAction:(UIButton *)sender {
    sender.hidden = YES;
    [videoClient call:self.device_id];
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    isConnect = NO;
}


#pragma mark - RBLiveVideoDelegate
/**
 *  @author 智奎宇, 16-11-23 17:11:43
 *
 *  视频连接进度
 *
 *  @param progress 连接进度（0 - 1）
 */
- (void)connectProgress:(float)progress{
    if(progress == 1){
        [_loadingView stopAnimating];
        _loadingView.hidden = YES;
        isConnect = YES;
    }
}

/**
 *  @author 智奎宇, 16-11-23 17:11:16
 *
 *  视频连接出错错误
 *
 *  @param error 错误码
 */
- (void)connectVideoStateError:(RB_CALL_ERROR)error{
    NSString * tipString = nil;
    
    switch (error) {
        case RB_NO_LOGIN:
            tipString = @"没有登陆（roobo 账号系统，没有登陆）" ;
            break;
        case RB_CLOSE:
            tipString = @"对方或者服务器断开" ;
            break;
        case RB_NOLOGIN:
            tipString = @"视频服务器没有登陆成功" ;
            break;
        case RB_OFFLINE:
            tipString = @"对方端没有在线" ;
            break;
        case RB_HALLON:
            tipString = @"对方休眠贴打开" ;
            break;
        case RB_BUSY:
            tipString = @"对方忙" ;
            break;
        case RB_TIMEOUT:
            tipString = @"呼叫超时" ;
            break;
        case RB_UNKNOW:
            tipString = @"其他错误" ;
            break;
        default:
            break;
    }
    if(tipString){
        [self showMessage:tipString duration:3];
    }
    self.reconnectBtn.hidden = NO;
    self.loadingView.hidden = YES;
    isConnect = NO;
}

/**
 *  @author 智奎宇, 16-11-23 17:11:14
 *
 *  视频截图
 *
 *  @param img 图片
 */
- (void)onCaptureImage:(UIImage *)img{

    [self showImage:img duration:3];

}
/**
 *  @author 智奎宇, 16-11-23 17:11:00
 *
 *  视频录制状态回调
 *
 *  @param event 视频状态
 *  @param error 错误码
 *  @param videoOutPutPath 视频要输出的路径
 */
- (void)onRecored:(RB_RECORD)event ERROR:(RECORD_ERROR)error OutPutPath:(NSString *)videoOutPutPath{
    NSString * tipString = nil;

    switch (event) {
        case RB_RECORD_STARTED:
            tipString = @"开始录制视频" ;
            break;
        case RB_RECORD_STOPED:
            tipString = [NSString stringWithFormat:@"结束录制视频 视频地址 %@",videoOutPutPath];
            break;
        case RB_RECORD_ERROR:
            tipString = @"录制视频错误" ;
            break;
        default:
            break;
    }
    [self showMessage:tipString duration:3];

}
/**
 *  @author 智奎宇, 16-11-23 17:11:06
 *
 *  有端人加入视频会话
 *
 *  @param sid  对方会话的id
 *  @param view 对方数据的view
 */
- (void)onVideoRendering:(uint64_t )sid View:(UIView *)view{
    [self.view insertSubview:view aboveSubview:self.videoSpaceView];
    view.frame = _videoSpaceView.frame;
}

/**
 *  @author 智奎宇, 16-11-23 17:11:46
 *
 *  有端离开会话
 *
 *  @param sid  对方会话的id
 *  @param view 对方数据的view
 */
- (void)onVideoDismiss:(uint64_t )sid View:(UIView *)view{
    [view removeFromSuperview];

}

@end
