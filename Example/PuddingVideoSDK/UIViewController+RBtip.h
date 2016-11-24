//
//  UIViewController+RBtip.h
//  PuddingVideoSDK
//
//  Created by Zhi Kuiyu on 2016/11/24.
//  Copyright © 2016年 zhiyu330691038. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RBtip)
-(void)showMessage:(NSString *)message duration:(NSTimeInterval)time;
-(void)showImage:(UIImage *)message duration:(NSTimeInterval)time;
@end
