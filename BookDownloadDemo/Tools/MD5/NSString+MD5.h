//
//  NSString+MD5.h
//  BookDownloadDemo
//
//  Created by MountainX on 2018/1/17.
//  Copyright © 2018年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

/**
 哈希算法计算字符串的摘要

 @return 128bit的数据
 */
- (NSString *)MD5;


/**
 哈希算法计算文件的摘要(self为文件所在路径)

 @return 128bit的数据
 */
- (NSString *)fileMD5;

@end
