//
//  UIViewController+RBtip.m
//  PuddingVideoSDK
//
//  Created by Zhi Kuiyu on 2016/11/24.
//  Copyright © 2016年 zhiyu330691038. All rights reserved.
//

#import "UIViewController+RBtip.h"

@implementation UIViewController (RBtip)
-(void)showMessage:(NSString *)message duration:(NSTimeInterval)time
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor grayColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f],
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [message boundingRectWithSize:CGSizeMake(207, 999)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes context:nil].size;
    
    label.frame = CGRectMake(10, 5, labelSize.width +20, labelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    
    showview.frame = CGRectMake((screenSize.width - labelSize.width - 20)/2,
                                screenSize.height - 300,
                                labelSize.width+40,
                                labelSize.height+10);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3 animations:^{
            showview.alpha = 0;
        } completion:^(BOOL finished) {
            [showview removeFromSuperview];
        }];
    });
}


-(void)showImage:(UIImage *)message duration:(NSTimeInterval)time
{
    if(message == nil) return;
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor grayColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    CGSize imgsize = message.size;
    
    float height = imgsize.height/imgsize.width * 200 ;
    imgsize = CGSizeMake(200, height);
    UIImageView * imageView = [[UIImageView alloc] initWithImage:message];
    imageView.frame = CGRectMake(10, 5, imgsize.width, imgsize.height);
    [showview addSubview:imageView];

    
    
    showview.frame = CGRectMake((screenSize.width - imgsize.width - 20)/2,
                                screenSize.height - 300,
                                imgsize.width+20,
                                imgsize.height+10);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3 animations:^{
            showview.alpha = 0;
        } completion:^(BOOL finished) {
            [showview removeFromSuperview];
        }];
    });
}


@end
