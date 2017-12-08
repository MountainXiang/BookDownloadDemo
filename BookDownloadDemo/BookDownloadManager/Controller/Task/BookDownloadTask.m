//
//  BookDownloadTask.m
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/5.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "BookDownloadTask.h"
#import "DownloadBaseOperation.h"
#import "BookDownload.h"
#import "DownloadOperationQueue.h"

@interface BookDownloadTask()

@property (nonatomic, copy) NSString *taskID;

@property (nonatomic, strong)DownloadBaseOperation *operation;

@end

@implementation BookDownloadTask

#pragma mark - Public Method
- (instancetype)initWithTaskID:(NSString *)taskID {
    if (self = [super init]) {
        _taskID = taskID;
    }
    return self;
}

- (void)beginDownload {
//    [[DownloadOperationQueue sharedQueue] addOperationWithBlock:^{
//        NSLog(@"====beginDownload====%@", _taskID);
//    }];
    
    [[DownloadOperationQueue sharedQueue] addOperation:self.operation];
}

#pragma mark - Private Method

#pragma mark - Getter
- (DownloadBaseOperation *)operation {
    if (!_operation) {
        _operation = [[DownloadBaseOperation alloc] initWithOperationID:_taskID];
    }
    return _operation;
}

@end
