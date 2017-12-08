//
//  DownloadNetworkManager.h
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/6.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadNetworkManager : NSObject

+ (NSURLSessionDataTask *)getBookDownloadInfoWithBookGuid:(NSString *)bookGuid success:(successBlock)success failure:(failureBlock)failure;

@end
