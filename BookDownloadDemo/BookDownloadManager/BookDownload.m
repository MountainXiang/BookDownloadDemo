//
//  BookDownload.m
//  BookDownloadDemo
//
//  Created by MountainX on 2017/11/23.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "BookDownload.h"
#import "BookDownloadTask.h"

@interface BookDownload()

@property (nonatomic, strong)dispatch_queue_t downloadQueue;

@end

@implementation BookDownload

static BookDownload *_sharedInstance = nil;

#pragma mark - Singleton Pattern
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance) {
            _sharedInstance = [[[self class] alloc] init];
        }
    });
    return _sharedInstance;
}

- (instancetype)init {
    if (self == [super init]) {
        NSString *queueLabel = [NSString stringWithFormat:@"com.mxrcorp.BoMXR_Web_Url_DeclarationationQueue-%@",[[NSUUID UUID] UUIDString]];
        dispatch_queue_t concurrentQueue = dispatch_queue_create([queueLabel cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_CONCURRENT);
        _downloadQueue = concurrentQueue;
    }
    return self;
}

-(void)downloadBook:(NSString *)bookGUID {
    /*
     dispatch_async函数将block或函数添加到queue中，且添加后立即返回，不需要等待block或函数被执行完成。其中由queue的类型来决定同一个dispatch queue是串行还是并行执行，而不同的dispatch queue则都是并行执行的。
     dispatch_sync函数同样受queue的类型决定。
    */
    dispatch_sync(_downloadQueue, ^{
        BookDownloadTask *task = [[BookDownloadTask alloc] initWithTaskID:bookGUID];
        [task beginDownload];
    });
}

/*
 Dispatch queue的实现机制是基于C实现的，并且GCD自动为用户提供了一些dispatch queue，当然也可以自定义一些queue。其中queue类型只有三种：Serial、Concurrent和Main dispatch queue。
 
 dispatch queue类型:
 
 Serial（串行）
 
 又称为private dispatch queues，同一时刻只执行一个任务，并按添加到serial的顺序执行。当创建多个Serial queue时，虽然它们各自是同步执行的，但Serial queue与Serial queue之间是并发执行的。Serial queue通常用于同步访问特定的资源或数据。
 
 Concurrent（并行）
 
 又称为global dispatch queue，同一时刻可执行多个任务，任务开始执行的顺序按添加的顺序执行，但是执行完成的顺序是随机的，同时可以创建执行的任务数量依赖系统条件。
 
 Main dispatch queue（主队列）
 
 它是全局可用的serial queue，它是在应用程序主线程上执行任务的。
 */

@end
