//
//  DownloadBaseOperation.m
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/5.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "DownloadBaseOperation.h"
#import "DownloadOperationQueue.h"
#import "DownloadNetworkManager.h"
#import "MTXDownloadManager.h"
#import "MTXFileManager.h"
#import "NSString+MD5.h"

@interface DownloadBaseOperation()

@property (nonatomic, copy) NSString *operationID;

@end

@implementation DownloadBaseOperation

- (instancetype)initWithOperationID:(NSString *)operationID {
    if (self = [super init]) {
        _operationID = operationID;
    }
    return self;
}

- (void)start {
    [super start];
//    NSLog(@"====%s====%@====%d====%lu====%@====%d", __FUNCTION__,_operationID, self.asynchronous, (unsigned long)[DownloadOperationQueue sharedQueue].operations.count, [NSThread currentThread], [NSThread isMainThread]);
    
//    @autoreleasepool {
//        [self startDownload];
//    }
}

// 当把自定义的操作添加到操作队列中，或者直接调用操作的start方法后，都会自动来执行main 方法中的内容
- (void)main {
    [super main];
//    NSLog(@"====%s====%@====%d====%lu====%@====%d", __FUNCTION__,_operationID, self.asynchronous, (unsigned long)[DownloadOperationQueue sharedQueue].operations.count, [NSThread currentThread], [NSThread isMainThread]);

//    dispatch_queue_t queue = dispatch_queue_create("Log_Finish_Queue", NULL);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), queue, ^{
//        NSLog(@"====finish====%@====%d====%lu====%@====%d", _operationID, self.asynchronous, (unsigned long)[DownloadOperationQueue sharedQueue].operations.count, [NSThread currentThread], [NSThread isMainThread]);
//    });
    
    @autoreleasepool {
        [self startDownload];
    }
}

- (void)dealloc {
//    NSLog(@"====%s====", __FUNCTION__);
}

#pragma mark - Private Method
- (void)startDownload {
    //http://books.mxrcorp.cn/5D46BB7762E54116846B04ED6C9F15C8/UserPicture/bookIcon.png
    //http://books.mxrcorp.cn/5D46BB7762E54116846B04ED6C9F15C8/P1.zip 空文件夹
    //http://books.mxrcorp.cn/69804558FF954B6691AA22714D263FFF/P01.zip
    NSString *downloadURL = @"http://books.mxrcorp.cn/69804558FF954B6691AA22714D263FFF/P01.zip";
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
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        DLog(@"====downloadProgress====%lf",downloadProgress.fractionCompleted);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        /*file:///Users/mxr/Library/Developer/CoreSimulator/Devices/F0A41D22-52BE-4F30-A200-F9DD0FA44D3F/data/Containers/Data/Application/87BF2004-076B-4E5C-A293-8D17B2184B35/Documents/P01.zip*/
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *targetURL = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        /*AFNetworking下载临时文件路径：
        /Users/mxr/Library/Developer/CoreSimulator/Devices/F0A41D22-52BE-4F30-A200-F9DD0FA44D3F/data/Containers/Data/Application/E64F5963-D51A-45CC-B940-A331D4D33BC3/tmp/CFNetworkDownload_FoJ2w2.tmp
         */
//        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//        NSString *targetURLStr = [docDir stringByAppendingPathComponent:[response suggestedFilename]];
//        NSURL *targetURL = [NSURL URLWithString:targetURLStr];
//        [[MTXFileManager defaultManager] createDirectoryAtPath:targetURLStr];
        
        
        return targetURL;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            DLog(@"Download Error:%@", error.localizedDescription);
            /*Download Error:The resource could not be loaded because the App Transport Security policy requires the use of a secure connection.*/
        } else {
            DLog(@"DownLoad Success====filePath: %@", filePath);
            NSString *fileRealPath;
            //Method 1:
            /*
             filePath:
             真机:
             file:///var/mobile/Containers/Data/Application/D10579DD-84E4-4D27-883D-D8D104ABFEEE/Documents/P01.zip
             模拟器：
             file:///Users/mxr/Library/Developer/CoreSimulator/Devices/F0A41D22-52BE-4F30-A200-F9DD0FA44D3F/data/Containers/Data/Application/038D5E07-132B-48C5-BE56-2A3DF6EF0CCC/Documents/P01.zip
             */
            NSString *prefix = @"file://";
            if ([filePath.absoluteString hasPrefix:prefix]) {
                fileRealPath = [filePath.absoluteString substringFromIndex:prefix.length];
            } else {
                fileRealPath = filePath.absoluteString;
            }
            
            //Method 2:
            /*
             真机:
             /var/mobile/Containers/Data/Application/8AD4DAC7-BFE6-4E88-9CA3-DF54445DFC7E/Documents/P01.zip
             模拟器：
             /Users/mxr/Library/Developer/CoreSimulator/Devices/F0A41D22-52BE-4F30-A200-F9DD0FA44D3F/data/Containers/Data/Application/6267B3A2-C31E-4CDA-AC29-B882DBF784C2/Documents/P01.zip
             */
//            NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//            fileRealPath = [documentDir stringByAppendingPathComponent:[response suggestedFilename]];
            
            DLog(@"fileRealPath:%@", fileRealPath);
            
            //MD5校验 下载文件MD5(标准为全小写)与服务器返回的MD5转化为小写(lowercaseString)后对比即可
            NSString *fileMD5 = [fileRealPath fileMD5];
            DLog(@"fileMD5:%@", fileMD5);//fileMD5:aeadb39c922df5cec6d358614fc53f4f
            
            [[MTXFileManager defaultManager] upzipFileAtPath:fileRealPath];
        }
    }];
    [downloadTask resume];
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

/*
 并发数
 （1）并发数:同时执⾏行的任务数.比如,同时开3个线程执行3个任务,并发数就是3
 （2）最大并发数：同一时间最多只能执行的任务的个数。
 （3）最⼤大并发数的相关⽅方法
 - (NSInteger)maxConcurrentOperationCount;
 - (void)setMaxConcurrentOperationCount:(NSInteger)cnt;
 说明：如果没有设置最大并发数，那么并发的个数是由系统内存和CPU决定的，可能内存多久开多一点，内存少就开少一点。
 注意：num的值并不代表线程的个数，仅仅代表线程的ID。
 提示：最大并发数不要乱写（5以内），不要开太多，一般以2~3为宜，因为虽然任务是在子线程进行处理的，但是cpu处理这些过多的子线程可能会影响UI，让UI变卡。
 */

/*
 NSOperation有一个属性，isConcurrent.
 Operation queues usually provide the threads used to run their operations. In OS X v10.6 and later, operation queues use the libdispatch library (also known as Grand Central Dispatch) to initiate the execution of their operations. As a result, operations are always executed on a separate thread, regardless of whether they are designated as concurrent or non-concurrent operations. In OS X v10.5, however, operations are executed on separate threads only if their isConcurrent method returns NO. If that method returns YES, the operation object is expected to create its own thread (or start some asynchronous operation); the queue does not provide a thread for it.
 在ios4以前，只有非并发的情况下，队列会为operation开启一个线程来执行。如果是并发的情况，operation需要自己创建一个线程来执行。所以说，NSoperation的并发和非并发不是传统意义上的串行和并行。
 但是在ios4以后，不管是并发还是非并发，队列都会为operation提供一个线程来执行。所以isConcurrent这个变量也就没有用处了。
 
 @property (readonly, getter=isConcurrent) BOOL concurrent; // To be deprecated; use and override 'asynchronous' below
 @property (readonly, getter=isAsynchronous) BOOL asynchronous API_AVAILABLE(macos(10.8), ios(7.0), watchos(2.0), tvos(9.0));
 
 但是，这里还设涉及到了两个方法，start和main.
 按照官方文档所说，如果是非并发就使用main，并发就使用start。
 那现在并发和非并发已经没有区别了，start和main的区别在哪里呢？
 main方法的话，如果main方法执行完毕，那么整个operation就会从队列中被移除。如果你是一个自定义的operation并且它是某些类的代理，这些类恰好有异步方法，这时就会找不到代理导致程序出错了。
 然而start方法就算执行完毕，它的finish属性也不会变，因此你可以控制这个operation的生命周期了。
 然后在任务完成之后手动cancel掉这个operation即可。
 */

/*
 2017-12-06 11:23:36.244192+0800 BookDownloadDemo[7737:137633] ====main====book_0====0====10====<NSThread: 0x60000046c7c0>{number = 7, name = (null)}====0
 2017-12-06 11:23:36.244192+0800 BookDownloadDemo[7737:137632] ====main====book_6====0====10====<NSThread: 0x60000046c780>{number = 6, name = (null)}====0
 2017-12-06 11:23:36.244212+0800 BookDownloadDemo[7737:137624] ====main====book_2====0====9====<NSThread: 0x60000046c640>{number = 3, name = (null)}====0
 2017-12-06 11:23:36.244247+0800 BookDownloadDemo[7737:137638] ====main====book_1====0====10====<NSThread: 0x60000046c740>{number = 8, name = (null)}====0
 2017-12-06 11:23:36.244251+0800 BookDownloadDemo[7737:137627] ====main====book_3====0====9====<NSThread: 0x60000046c6c0>{number = 4, name = (null)}====0
 2017-12-06 11:23:36.244555+0800 BookDownloadDemo[7737:137633] ====start====book_0====0====8====<NSThread: 0x60000046c7c0>{number = 7, name = (null)}====0
 2017-12-06 11:23:36.244572+0800 BookDownloadDemo[7737:137632] ====start====book_6====0====7====<NSThread: 0x60000046c780>{number = 6, name = (null)}====0
 2017-12-06 11:23:36.244622+0800 BookDownloadDemo[7737:137624] ====start====book_2====0====7====<NSThread: 0x60000046c640>{number = 3, name = (null)}====0
 2017-12-06 11:23:36.244663+0800 BookDownloadDemo[7737:137639] ====main====book_9====0====7====<NSThread: 0x60000046c700>{number = 9, name = (null)}====0
 2017-12-06 11:23:36.244902+0800 BookDownloadDemo[7737:137640] ====main====book_4====0====7====<NSThread: 0x604000270b80>{number = 10, name = (null)}====0
 2017-12-06 11:23:36.245173+0800 BookDownloadDemo[7737:137643] ====main====book_5====0====7====<NSThread: 0x604000270380>{number = 11, name = (null)}====0
 2017-12-06 11:23:36.245283+0800 BookDownloadDemo[7737:137622] ====main====book_8====0====10====<NSThread: 0x60400026fac0>{number = 5, name = (null)}====0
 2017-12-06 11:23:36.245309+0800 BookDownloadDemo[7737:137642] ====main====book_7====0====7====<NSThread: 0x60000046cc40>{number = 12, name = (null)}====0
 2017-12-06 11:23:36.245945+0800 BookDownloadDemo[7737:137638] ====start====book_1====0====6====<NSThread: 0x60000046c740>{number = 8, name = (null)}====0
 2017-12-06 11:23:36.246085+0800 BookDownloadDemo[7737:137627] ====start====book_3====0====5====<NSThread: 0x60000046c6c0>{number = 4, name = (null)}====0
 2017-12-06 11:23:36.246633+0800 BookDownloadDemo[7737:137639] ====start====book_9====0====4====<NSThread: 0x60000046c700>{number = 9, name = (null)}====0
 2017-12-06 11:23:36.246715+0800 BookDownloadDemo[7737:137640] ====start====book_4====0====3====<NSThread: 0x604000270b80>{number = 10, name = (null)}====0
 2017-12-06 11:23:36.247136+0800 BookDownloadDemo[7737:137643] ====start====book_5====0====2====<NSThread: 0x604000270380>{number = 11, name = (null)}====0
 2017-12-06 11:23:36.247409+0800 BookDownloadDemo[7737:137622] ====start====book_8====0====1====<NSThread: 0x60400026fac0>{number = 5, name = (null)}====0
 2017-12-06 11:23:36.247617+0800 BookDownloadDemo[7737:137642] ====start====book_7====0====0====<NSThread: 0x60000046cc40>{number = 12, name = (null)}====0
 2017-12-06 11:23:41.247001+0800 BookDownloadDemo[7737:137517] ====finish====book_2====0====0====<NSThread: 0x600000068700>{number = 1, name = main}====1
 2017-12-06 11:23:41.247448+0800 BookDownloadDemo[7737:137517] ====finish====book_6====0====0====<NSThread: 0x600000068700>{number = 1, name = main}====1
 2017-12-06 11:23:41.247735+0800 BookDownloadDemo[7737:137517] ====finish====book_0====0====0====<NSThread: 0x600000068700>{number = 1, name = main}====1
 2017-12-06 11:23:41.247997+0800 BookDownloadDemo[7737:137517] ====finish====book_1====0====0====<NSThread: 0x600000068700>{number = 1, name = main}====1
 2017-12-06 11:23:41.248221+0800 BookDownloadDemo[7737:137517] ====finish====book_3====0====0====<NSThread: 0x600000068700>{number = 1, name = main}====1
 2017-12-06 11:23:41.248410+0800 BookDownloadDemo[7737:137517] ====finish====book_9====0====0====<NSThread: 0x600000068700>{number = 1, name = main}====1
 2017-12-06 11:23:41.248562+0800 BookDownloadDemo[7737:137517] ====finish====book_4====0====0====<NSThread: 0x600000068700>{number = 1, name = main}====1
 2017-12-06 11:23:41.666063+0800 BookDownloadDemo[7737:137517] ====finish====book_5====0====0====<NSThread: 0x600000068700>{number = 1, name = main}====1
 2017-12-06 11:23:41.666353+0800 BookDownloadDemo[7737:137517] ====finish====book_8====0====0====<NSThread: 0x600000068700>{number = 1, name = main}====1
 2017-12-06 11:23:41.666609+0800 BookDownloadDemo[7737:137517] ====finish====book_7====0====0====<NSThread: 0x600000068700>{number = 1, name = main}====1
 */

@end
