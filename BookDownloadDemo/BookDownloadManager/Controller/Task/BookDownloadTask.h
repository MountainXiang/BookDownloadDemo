//
//  BookDownloadTask.h
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/5.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookDownloadTask : NSObject

- (instancetype)initWithTaskID:(NSString *)taskID;

- (void)beginDownload;

@end


