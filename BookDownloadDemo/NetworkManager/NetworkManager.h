//
//  NetworkManager.h
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/6.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define URLStringCat(_host_, _serviceurl_)     [[NSURL URLWithString:_serviceurl_ relativeToURL:[NSURL URLWithString:_host_]] absoluteString]

typedef enum : NSUInteger {
    RequestTypeGet,
    RequestTypePost,
    RequestTypeDelete,
} RequestType;

typedef void(^successBlock)(id _Nullable data);

typedef void(^failureBlock)(NSError * _Nullable error);

@interface NetworkManager : AFHTTPSessionManager

- (NSURLSessionDataTask *_Nullable)requestWithType:(RequestType)type
                                         URLString:(NSString *_Nullable)URLString
                                        parameters:(id _Nullable )parameters
                                          progress:(void (^_Nullable)(NSProgress *_Nonnull))downloadProgress
                                           success:(void (^_Nullable)(NSURLSessionDataTask *_Nonnull, id _Nullable))success
                                           failure:(void (^_Nullable)(NSURLSessionDataTask *_Nullable, NSError * _Nullable _Nonull))failure;

@end
