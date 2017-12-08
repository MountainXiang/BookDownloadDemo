//
//  DownloadNetworkManager.h
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/6.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadNetworkManager : NSObject

/**
 获取图书资源地址

 @param bookGuid 唯一标识
 @param success 返回
 @param failure 失败
 @return 请求任务
 */
+ (NSURLSessionDataTask *)getBookDownloadInfoWithBookGuid:(NSString *)bookGuid success:(successBlock)success failure:(failureBlock)failure;

+ (void)test;

@end
