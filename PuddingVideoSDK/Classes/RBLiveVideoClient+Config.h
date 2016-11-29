//
//  RBLiveVideoClient+Config.h
//  PuddingVideo
//
//  Created by Zhi Kuiyu on 2016/11/28.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBLiveVideoClient.h"


typedef enum {
    RBLogDisable,
    RBLogBase,
    RBLogAll,
} RBLogModle;


typedef enum {
    RBDeveloper,
    RBOnLine,
    
}RBEnvi;



bool RBBaseLogEnable = false;


#define RBLog(format,...)  \
if(RBBaseLogEnable) \
printf("\n[%s] %s %s\n", __TIME__, __FUNCTION__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String])\



@interface RBLiveVideoClient (Config)

+ (void)setLogModle:(RBLogModle)modle;

+ (void)setVideoEnvironment:(RBEnvi)env;

+ (void)userInfo:(NSString *)userid Token:(NSString *)token;

@end
