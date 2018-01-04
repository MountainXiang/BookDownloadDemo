//
//  DownloadNetworkManager.m
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/6.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "DownloadNetworkManager.h"
#import "MXRBase64.h"
#import "NetworkResponse.h"
#import "BookDownloadInfo.h"
#import "BookDataBaseManager.h"

static NSString * const MXRBASE_API_URL = @"https://bs-api.mxrcorp.cn";

#define SuffixURL_DOWNLOAD_FILELIST(__bookGUID)             [NSString stringWithFormat:@"areditor/release/filelist/%@",__bookGUID]
#define ServiceURL_DOWNLOAD_FILELIST(__bookGUID)            URLStringCat(MXRBASE_API_URL, SuffixURL_DOWNLOAD_FILELIST(__bookGUID))

@implementation DownloadNetworkManager

+ (NSURLSessionDataTask *)getBookDownloadInfoWithBookGuid:(NSString *)bookGuid success:(successBlock)success failure:(failureBlock)failure {
    NSString *URLString = ServiceURL_DOWNLOAD_FILELIST(bookGuid);
    return [[NetworkManager manager] requestWithType:RequestTypeGet URLString:URLString parameters:nil progress:^(NSProgress * _Nonnull progress) {
        //打印下下载进度
        DLog(@"====downloadProgress====%lf",1.0 * progress.completedUnitCount / progress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable data) {
        if (success) {//判空
            NetworkResponse *response = [[NetworkResponse alloc] initWithData:data];
        
            if (response.errCode == 0 && [response.body isKindOfClass:[NSDictionary class]]) {
                BookDownloadInfo *info = [[BookDownloadInfo alloc] init];
                info.bookGuid = bookGuid;//先设置BookGuid
                [info setValuesForKeysWithDictionary:response.body];
                info.createTime = [NSString currentTime];
                info.updateTime = info.createTime;
                [[BookDataBaseManager sharedManager] insertModelByAsyncToDB:info callback:^(BOOL result) {
                    DLog(@"====insert====%@", result ? @"success" : @"fail");
                }];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        if (failure) {//判空
            failure(error);
        }
        /*Printing description of error:
         Error Domain=NSURLErrorDomain Code=-1002 "unsupported URL" UserInfo={NSUnderlyingError=0x600000254c40 {Error Domain=kCFErrorDomainCFNetwork Code=-1002 "(null)"}, NSErrorFailingURLStringKey=//areditor/release/filelist/5D46BB7762E54116846B04ED6C9F15C8, NSErrorFailingURLKey=//areditor/release/filelist/5D46BB7762E54116846B04ED6C9F15C8, */
    }];
}

+ (void)test {
    NSString *downloadURL = @"http://books.mxrcorp.cn/5D46BB7762E54116846B04ED6C9F15C8/P1.zip";
    NSTimeInterval timeoutInterval = 30;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:downloadURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeoutInterval];
    request.HTTPMethod = @"GET";
    
//    NSString *userAgent;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wgnu"
//#if TARGET_OS_IOS
//    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
//    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
//#elif TARGET_OS_WATCH
//    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
//    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; watchOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[WKInterfaceDevice currentDevice] model], [[WKInterfaceDevice currentDevice] systemVersion], [[WKInterfaceDevice currentDevice] screenScale]];
//#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
//    userAgent = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
//
//#else
//    userAgent = @"";
//#endif
//#pragma clang diagnostic pop
    
    NSString *userAgent = @"4dBookCity/5.8.1 (iPhone; iOS 11.1.2; Scale/3.00)";
    
    if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        NSMutableString *mutableUserAgent = [userAgent mutableCopy];
        if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
            userAgent = mutableUserAgent;
        }
    }
    
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    unsigned long long fileSize = 0;
    NSString *headerRange = [NSString stringWithFormat:@"bytes=%llu-", fileSize];
    [request setValue:headerRange forHTTPHeaderField:@"Range"];
    
    // 判断之前是否下载过 如果有下载重新构造Header
//    if ([fileManager fileExistsAtPath:tempFilePath]) {
//        NSError *error = nil;
//        fileSize = [[fileManager attributesOfItemAtPath:tempFilePath
//                                                  error:&error]
//                    fileSize];
//        if (error) {
//            DLOG(@"get %@ fileSize failed!\nError:%@", tempFilePath, error);
//        }
//        NSString *headerRange = [NSString stringWithFormat:@"bytes=%llu-", fileSize];
//        [request setValue:headerRange forHTTPHeaderField:@"Range"];
//    }
    
    /*--------Creating a Download Task--------*/
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
//    NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        DLog(@"downloadProgress====%lld",downloadProgress.completedUnitCount/ downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            DLog(@"Download Error:%@", error.localizedDescription);
        } else {
            DLog(@"DownLoad Success====filePath: %@", filePath);
            
            /*Download Error:The resource could not be loaded because the App Transport Security policy requires the use of a secure connection.*/
        }
    }];
    [downloadTask resume];
    /*--------Creating a Download Task--------*/
}

/*(lldb) po response.body
 {
 fileList =     (
 {
 fileMD5 = 72C50448820F04DB6FB39DDD5FD6B0F3;
 fileName = "http://books.mxrcorp.cn/5D46BB7762E54116846B04ED6C9F15C8/UserPicture/bookIcon.png";
 fileSize = 85629;
 fileType = 1;
 index = 0;
 },
 {
 fileMD5 = 50AC72F27E2F98910673A2BD35BD05CA;
 fileName = "http://books.mxrcorp.cn/5D46BB7762E54116846B04ED6C9F15C8/P1.zip";
 fileSize = 104;
 fileType = 1;
 index = 1;
 },
 {
 fileMD5 = 7FE5E4BBAAFA872D3BBFBCA86085A67C;
 fileName = "http://books.mxrcorp.cn/5D46BB7762E54116846B04ED6C9F15C8/P2.zip";
 fileSize = 104;
 fileType = 1;
 index = 2;
 },
 {
 fileMD5 = DCCB5C34F109B0969257C1B3C28F468E;
 fileName = "http://books.mxrcorp.cn/5D46BB7762E54116846B04ED6C9F15C8/P3.zip";
 fileSize = 104;
 fileType = 1;
 index = 3;
 },
 {
 fileMD5 = B4983A611CBD350D4AB095A5C8F92BB0;
 fileName = "http://books.mxrcorp.cn/5D46BB7762E54116846B04ED6C9F15C8/P4.zip";
 fileSize = 104;
 fileType = 1;
 index = 4;
 },
 {
 fileMD5 = 2508B512B65554D6828EA9BEE6BC3943;
 fileName = "http://books.mxrcorp.cn/5D46BB7762E54116846B04ED6C9F15C8/P5.zip";
 fileSize = 104;
 fileType = 1;
 index = 5;
 },
 {
 fileMD5 = CC3935D6D90179A7A47D8609178C093E;
 fileName = "http://books.mxrcorp.cn/5D46BB7762E54116846B04ED6C9F15C8/UserPicture/P1.jpg";
 fileSize = 693583;
 fileType = 1;
 index = 6;
 },
 {
 fileMD5 = F0FBE9B18FC3B703D3D78A75FC161E68;
 fileName = "http://books.mxrcorp.cn/5D46BB7762E54116846B04ED6C9F15C8/others.zip";
 fileSize = 6596689;
 fileType = 1;
 index = 7;
 },
 {
 fileMD5 = C967A5641E94C2E466137592FB5B997F;
 fileName = "http://books.mxrcorp.cn/5D46BB7762E54116846B04ED6C9F15C8/markers.zip";
 fileSize = 2783786;
 fileType = 1;
 index = 8;
 },
 {
 fileMD5 = 4B29D4DB20AC7CC2457F81D25C6EA709;
 fileName = "http://books.mxrcorp.cn/5D46BB7762E54116846B04ED6C9F15C8/readThrough.zip";
 fileSize = 122;
 fileType = 1;
 index = 9;
 }
 );
 fileUrl = "";
 preViewPages =     (
 6,
 1,
 7
 );
 }*/

@end
