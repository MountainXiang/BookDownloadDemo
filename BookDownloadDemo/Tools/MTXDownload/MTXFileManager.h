//
//  MTXFileManager.h
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/8.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

static NSString * const Root_Directory_Name  = @"MTXDownload";//下载根目录
static NSString * const Cache_Directory_Name = @"Cache";//完整文件目录
static NSString * const Temp_Directory_Name  = @"Temp";//临时文件目录

#define CACHES_Directory_PATH     [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

@interface MTXFileManager : NSObject

/**
 单例

 @return 实例对象
 */
+ (instancetype)defaultManager;

/**
 当前目录是否存在

 @param path 路径
 @return 是否存在
 */
- (BOOL)fileExistsAtPath:(NSString *)path;

/**
 创建目录

 @param path 目录路径
 @return 是否创建成功
 */
- (NSString *)createDirectoryAtPath:(NSString *)path;

/**
 解压文件到当前目录

 @param filePath 压缩文件路径
 @return 是否解压成功
 */
- (BOOL)upzipFileAtPath:(NSString *)filePath;

/**
 解压文件到指定目录

 @param filePath 压缩文件路径
 @param destination 解压指定目录
 @return 是否解压成功
 */
- (BOOL)unzipFileAtPath:(NSString *)filePath toDestination:(NSString *)destination;

/**
 解压文件到指定目录,解压成功后删除压缩文件

 @param filePath 压缩文件路径
 @param destination 解压指定目录
 @param deleteAfterUnzip 解压成功后是否删除压缩文件(默认为YES)
 @return 是否解压成功
 */
- (BOOL)unzipFileAtPath:(NSString *)filePath toDestination:(NSString *)destination deleteAfterUnzip:(BOOL)deleteAfterUnzip;

@end
