//
//  NetworkManager.m
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/6.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "NetworkManager.h"
#import "HTTPHeaderField.h"

static NSString  * const MXR_HEADERKEY = @"mxr-key";

@implementation NetworkManager

- (NSURLSessionDataTask *_Nullable)requestWithType:(RequestType)type
                                         URLString:(NSString *_Nullable)URLString
                                        parameters:(id _Nullable )parameters
                                          progress:(void (^_Nullable)(NSProgress *_Nonnull))progress
                                           success:(void (^_Nullable)(NSURLSessionDataTask *_Nonnull, id _Nullable))success
                                           failure:(void (^_Nullable)(NSURLSessionDataTask *_Nullable, NSError * _Nullable))failure {
    [self.requestSerializer setValue:[HTTPHeaderField mxrHeader] forHTTPHeaderField:MXR_HEADERKEY];
    
    switch (type) {
        case RequestTypeGet:
            return [self GET:URLString parameters:parameters progress:progress success:success failure:failure];
            break;
        case RequestTypePost:
            return [self POST:URLString parameters:parameters progress:progress success:success failure:failure];
            break;
            case RequestTypeDelete:
            return [self DELETE:URLString parameters:parameters success:success failure:failure];
            break;
        default:
            break;
    }
}

@end
