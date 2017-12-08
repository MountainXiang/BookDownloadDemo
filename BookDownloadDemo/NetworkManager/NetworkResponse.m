//
//  NetworkResponse.m
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/7.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "NetworkResponse.h"
#import "MXRBase64.h"
#import "GTMBase64.h"

static NSString * const HeaderKey  = @"Header";
static NSString * const BodyKey    = @"Body";
static NSString * const ErrCodeKey = @"ErrCode";
static NSString * const ErrMsgKey  = @"ErrMsg";

@implementation NetworkResponse

/*
 Printing description of data:
 {
 Body = "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";
 Header =     {
 ErrCode = 0;
 ErrMsg = "<null>";
 };
 }
 */

- (instancetype)initWithData:(id)data {
    if (self = [super init]) {
        [self parseData:data];
    }
    return self;
}

#pragma mark - Parse Data
- (void)parseData:(id)data {
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDict = data;
        NSDictionary *headerDict = [dataDict objectForKey:HeaderKey];
        NSString *bodyStr = [dataDict objectForKey:BodyKey];
        if ([headerDict isKindOfClass:[NSDictionary class]]) {
            _errCode = [[headerDict objectForKey:ErrCodeKey] integerValue];
            _errMsg = [NSString stringWithFormat:@"%@", [headerDict objectForKey:ErrMsgKey]];
        }
        if ([bodyStr isKindOfClass:[NSString class]]) {
//            NSData *decodedData = [GTMBase64 decodeString:bodyStr];
//            if (decodedData) {
//                NSError *error;
//                _body = [NSJSONSerialization JSONObjectWithData:decodedData options:NSJSONReadingMutableContainers error:&error];
//            }
            
            //Base64 + 按位运算，左移、右移运算进行解密
            NSString * _Nullable parsedBody = [MXRBase64 decodeBase64WithString:bodyStr];
            if (parsedBody) {
                NSError *error;
                _body = [NSJSONSerialization JSONObjectWithData:[parsedBody dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
            }
        }
    }
}

@end
