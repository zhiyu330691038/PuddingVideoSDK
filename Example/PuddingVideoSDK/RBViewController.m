//
//  RBViewController.m
//  player_demo
//
//  Created by Zhi Kuiyu on 16/6/24.
//  Copyright © 2016年 tcp china. All rights reserved.
//

#import "RBViewController.h"
#import "RBLiveVideoClient.h"
#import <RooboSDK/RBUserApi.h>
#import <RooboSDK/RBDeviceApi.h>
#import <RooboSDK/RBUserModel.h>
#import <RooboSDK/RBUserModel.h>
#import "RBLiveVideoClient+Config.h"
#import "RBVideoViewController.h"

@interface RBViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    RBUserModel       * userModle;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLable;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginOutBtn;

@end

@implementation RBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    videoClient = [RBLiveVideoClient getInstanse:@"appkey" AppID:@"appid" Client:@"pudding"];
    float width = [UIScreen mainScreen].bounds.size.width;
    
    videoClient.backgroundTime = 10;
    [RBLiveVideoClient setLogModle:RBLogBase];
//    [RBLiveVideoClient userInfo:@"ps:58cb4143bbdfe51eceb4bfe4ea2c27b1" Token:@"9a1fa150b23bb4de0f4d5b4aba3ae2b5"];
//    [RBLiveVideoClient setVideoEnvironment:RBDeveloper];
    
    UIView * vi  =[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 64)];
    vi.backgroundColor = [UIColor colorWithRed:97/255.0 green:212/255.0 blue:255/255.0 alpha:1];
    [self.view addSubview:vi];
    
    
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.text = @"视频SDK DEMO";
    lab.center = CGPointMake(width*0.5, 20+lab.frame.size.height*0.5);
    [vi addSubview:lab];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    
    [videoClient connect];


}

- (IBAction)loginOutAction:(id)sender {
    userModle = nil;
    _accountNameLable.text = userModle.name;
    _loginBtn.hidden = NO;
    _loginOutBtn.hidden = YES;
    _tipLab.hidden = YES;
    _accountNameLable.hidden = YES;
    [videoClient disConnect];
    [_tableview reloadData];

}
- (IBAction)loginAction:(id)sender {
    
    [RBUserApi userLoginWithBackBtnHidden:NO login:^(RBUserModel * _Nullable userModel, NSError * _Nullable error) {
        userModle = userModel;
        _accountNameLable.text = userModle.name;
        [videoClient connect];
        _loginBtn.hidden = YES;
        _loginOutBtn.hidden = NO;
        _tipLab.hidden = NO;
        _accountNameLable.hidden = NO;
        [_tableview reloadData];
    } Regist:nil Forget:nil];
 
}


- (void)showTip:(NSString *)tip{
    UIAlertView * vi = [[UIAlertView alloc]initWithTitle:@"提示" message:tip delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [vi show];
}


- (void)toVideoViewController:(NSString *)deviceId{
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main"bundle:nil];
    
    RBVideoViewController *nextViewController =[board instantiateViewControllerWithIdentifier:@"RBVideoViewController"];
    nextViewController.device_id = deviceId;
    [self.navigationController pushViewController:nextViewController animated:YES];
}

#pragma mark - TableView
#pragma mark  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RBDeviceModel * device =  [userModle.devices objectAtIndex:indexPath.row];
    if(device.online){
        [self toVideoViewController:device.device_id];
    
    }else{
        [self showTip:@"设备不在线"];
    }
}

#pragma mark  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [userModle.devices count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
    }
    
    RBDeviceModel * device =  [userModle.devices objectAtIndex:indexPath.row];
    
    NSString * name = [device.name length] > 7 ?[device.name substringToIndex:7]:device.name;

    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",device.device_id,name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",device.online ? @"在线":@"离线"];
    cell.detailTextLabel.textColor = [UIColor redColor];
    return cell;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
@end
