//
//  MTXDownloadManager.h
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/8.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTXDownloadManager : NSObject

/** 设置最大的并发下载个数 */
@property (nonatomic, assign) NSInteger              maxCount;
/** 已下载完成的文件列表（文件对象） */
@property (atomic, strong, readonly) NSMutableArray  *finishedFiles;
/** 正在下载的文件列表(ASIHttpRequest对象) */
@property (atomic, strong, readonly) NSMutableArray  *downingFiles;
/** 未下载完成的临时文件数组（文件对象) */
@property (atomic, strong, readonly) NSMutableArray  *tempFiles;

+ (instancetype)sharedManager;

@end
