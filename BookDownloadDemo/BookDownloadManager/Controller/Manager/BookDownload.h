//
//  BookDownload.h
//  BookDownloadDemo
//
//  Created by MountainX on 2017/11/23.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookDownload : NSObject

+ (instancetype)sharedInstance;

- (void)downloadBook:(NSString *)bookGUID;

@end
