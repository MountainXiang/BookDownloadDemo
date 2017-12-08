//
//  DownloadOperationQueue.m
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/6.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "DownloadOperationQueue.h"

@implementation DownloadOperationQueue

static DownloadOperationQueue *_sharedQueue = nil;

#pragma mark - Singleton Pattern
+ (instancetype)sharedQueue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedQueue) {
            _sharedQueue = [[[self class] alloc] init];
        }
    });
    return _sharedQueue;
}

/*
 •NSThread:
 –优点：NSThread 比其他两个轻量级，使用简单
 –缺点：需要自己管理线程的生命周期、线程同步、加锁、睡眠以及唤醒等。线程同步对数据的加锁会有一定的系统开销
 
 •NSOperation：
 –不需要关心线程管理，数据同步的事情，可以把精力放在自己需要执行的操作上
 –NSOperation是面向对象的
 
 •GCD：
 –Grand Central Dispatch是由苹果开发的一个多核编程的解决方案。iOS4.0+才能使用，是替代NSThread， NSOperation的高效和强大的技术
 –GCD是基于C语言的
 */

@end
