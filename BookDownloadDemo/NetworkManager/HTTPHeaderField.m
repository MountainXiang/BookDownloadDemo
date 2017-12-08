//
//  HTTPHeaderField.m
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/6.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "HTTPHeaderField.h"
#import "MXRBase64.h"
#define MXR_SOFT_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

/*
 // 开发中常用static修饰全局变量,只改变作用域
 
 // 为什么要改变全局变量作用域，防止重复声明全局变量。
 
 // 开发中声明的全局变量，有些不希望外界改动，只允许读取。
 
 // 比如一个基本数据类型不希望别人改动
 
 // 声明一个静态的全局只读常量
 static const int a = 20;
 
 // staic和const联合的作用:声明一个静态的全局只读常量
 
 // iOS中staic和const常用使用场景，是用来代替宏，把一个经常使用的字符串常量，定义成静态全局只读变量.
 
 // 开发中经常拿到key修改值，因此用const修饰key,表示key只读，不允许修改。
 static  NSString * const key = @"name";
 
 // 如果 const修饰 *key1,表示*key1只读，key1还是能改变。
 
 static  NSString const *key1 = @"name";
 */

//保留原来的
static NSString  * const MXR_OS_TYPE_KEY      = @"OS-Type";
static NSString  * const MXR_SOFT_VERSION_KEY = @"Soft-Version";

//增加新建的
static NSString  * const MXR_OS_TYPE_NEW_KEY       = @"osType";//设备类型（1,ios;2,android）
static NSString  * const MXR_SOFT_VERSION_NEW_KEY  = @"appVersion";
static NSString  * const MXR_DEVICE_ID_KEY         = @"deviceId";//服务端创建的deviceid，依赖于本地创建的deviceid
static NSString  * const MXR_USER_ID_KEY           = @"userId";
static NSString  * const MXR_REGION                = @"region";//区分国内版本和国际版（0，国内版；1，国际版）
static NSString  * const MXR_LOCAL_DEVICE_ID_KEY   = @"deviceUnique";//本地创建的deviceid
static NSString  * const MXR_APP_ID_KEY          =  @"appId"; // 渠道

@implementation HTTPHeaderField

+ (NSString *)mxrHeader {
    NSString * deviceId = @"";
    NSString * userId = @"0";
    NSString * deviceUnique = @"";
    NSString * region = @"0";
    NSString * appId = @"10000000000000000000000000000001";
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          userId,MXR_USER_ID_KEY,
                          deviceId,MXR_DEVICE_ID_KEY,
                          region,MXR_REGION,
                          MXR_SOFT_VERSION,MXR_SOFT_VERSION_NEW_KEY,
                          @"1",MXR_OS_TYPE_NEW_KEY,
                          deviceUnique,MXR_LOCAL_DEVICE_ID_KEY,
                          appId,MXR_APP_ID_KEY,
                          nil];
    NSString *value = [MXRBase64 encodeBase64WithString:[self dictionaryToJson:dict]];
    return value;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    if (dic) {
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&parseError];
        if (jsonData) {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    
    return nil;
}


@end
