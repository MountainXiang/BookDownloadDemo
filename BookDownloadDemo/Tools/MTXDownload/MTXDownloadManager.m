//
//  MTXDownloadManager.m
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/8.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "MTXDownloadManager.h"

@implementation MTXDownloadManager

static MTXDownloadManager *_manager = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[[self class] alloc] init];
    });
    return _manager;
}

- (void)startLoad {
    
}

@end
