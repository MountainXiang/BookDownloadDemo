//
//  MTXDownloadManager.m
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/8.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "MTXDownloadManager.h"
#import "MTXFileManager.h"

@implementation MTXDownloadManager

static MTXDownloadManager *_manager = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[[self class] alloc] init];
    });
    return _manager;
}

/*
 AFNetworking -> AFURLSessionManager:
 - (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
 progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
 destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
 completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
 {
 __block NSURLSessionDownloadTask *downloadTask = nil;
 url_session_manager_create_task_safely(^{
 downloadTask = [self.session downloadTaskWithRequest:request];
 });
 
 [self addDelegateForDownloadTask:downloadTask progress:downloadProgressBlock destination:destination completionHandler:completionHandler];
 
 return downloadTask;
 }
 
 - (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
 progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
 destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
 completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
 {
 __block NSURLSessionDownloadTask *downloadTask = nil;
 url_session_manager_create_task_safely(^{
 downloadTask = [self.session downloadTaskWithResumeData:resumeData];
 });
 
 [self addDelegateForDownloadTask:downloadTask progress:downloadProgressBlock destination:destination completionHandler:completionHandler];
 
 return downloadTask;
 }
 */
- (void)startLoad {
    //http://books.mxrcorp.cn/5D46BB7762E54116846B04ED6C9F15C8/UserPicture/bookIcon.png
    //http://books.mxrcorp.cn/5D46BB7762E54116846B04ED6C9F15C8/P1.zip
    NSString *downloadURL = @"http://books.mxrcorp.cn/5D46BB7762E54116846B04ED6C9F15C8/P1.zip";
    NSTimeInterval timeoutInterval = 30;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:downloadURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeoutInterval];
    request.HTTPMethod = @"GET";
    
    NSString *userAgent = @"4dBookCity/5.8.1 (iPhone; iOS 11.1.2; Scale/3.00)";
    
    if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        NSMutableString *mutableUserAgent = [userAgent mutableCopy];
        if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
            userAgent = mutableUserAgent;
        }
    }
    
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
//    unsigned long long fileSize = 0;
//    NSString *headerRange = [NSString stringWithFormat:@"bytes=%llu-", fileSize];
//    [request setValue:headerRange forHTTPHeaderField:@"Range"];
    
    /*--------Creating a Download Task--------*/
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
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
            [[MTXFileManager defaultManager] upzipFileAtPath:filePath.absoluteString];
        }
    }];
    [downloadTask resume];
    /*--------Creating a Download Task--------*/
}

@end
