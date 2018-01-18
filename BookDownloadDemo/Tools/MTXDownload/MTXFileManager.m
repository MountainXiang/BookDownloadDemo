//
//  MTXFileManager.m
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

#import "MTXFileManager.h"
#import <SSZipArchive/ZipArchive.h>

@interface MTXFileManager ()<SSZipArchiveDelegate>

@end

@implementation MTXFileManager

static MTXFileManager *_manager = nil;

#pragma mark - Singleton Pattern
+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [[MTXFileManager alloc] init];
        }
    });
    return _manager;
}

#pragma mark - Public Method
- (BOOL)fileExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (NSString *)createDirectoryAtPath:(NSString *)path {
    return [self createDirectoryAtPath:path preserveAttributes:YES];
}

- (NSString *)createDirectoryAtPath:(NSString *)path preserveAttributes:(BOOL)preserveAttributes {
    BOOL isDirectory = NO;
    //test
//    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//    path = documentsDirectoryURL.absoluteString;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    NSDictionary *directoryAttr;
    if (preserveAttributes) {//默认为YES
        NSDate *modDate = [NSDate date];
        directoryAttr = @{NSFileCreationDate: modDate, NSFileModificationDate: modDate};
    }
    
    if (isExists && isDirectory) {//目录已存在
        DLog(@"目录已存在:%@", path);
        return path;
    } else if (isExists && !isDirectory) {//文件已存在
        DLog(@"文件已存在:%@", path);
        return path;
    }
    
    // 参数1：创建的文件夹的路径
    // 参数2：是否创建媒介的布尔值，一般为YES（是否创建最终目录的不存在的父目录;是否连同上一级路径一起创建，NO 并且上一级文件路径不存在时会创建失败）
    // 参数3: 属性，没有就置为nil (目录的访问权限和修改时间)
    // 参数4: 错误信息
    NSError *err = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:directoryAttr error:&err];
    if (err) {
        DLog(@"createDirectoryAtPath(%@)Error:%@", path, err.localizedDescription);
        //You don’t have permission to save the file “Documents” in the folder “7F455894-C160-48D4-B849-1353704BF75D”.
    } else {
        DLog(@"createDirectoryAtPath(%@)Success", path);
        //获取文件属性
        NSError *error = nil;
        NSDictionary *fileAttributes =[[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
        //获取文件的创建日期
        NSDate *modificationDate = (NSDate*)[fileAttributes objectForKey: NSFileModificationDate];
        //获取文件的字节大小
        NSNumber *fileSize = (NSNumber*)[fileAttributes objectForKey: NSFileSize];
        if (error) {
            DLog(@"fileAttributesError:%@", error.localizedDescription);
        }
    }
    
    return path;
}

#pragma mark - 解压文件到当前目录
- (BOOL)upzipFileAtPath:(NSString *)filePath {
    NSString *destination = [filePath stringByDeletingLastPathComponent];
    return [self unzipFileAtPath:filePath toDestination:destination];
}

#pragma mark - 解压文件到指定目录
- (BOOL)unzipFileAtPath:(NSString *)filePath toDestination:(NSString *)destination {
    return [self unzipFileAtPath:filePath toDestination:destination deleteAfterUnzip:YES];
}

#pragma mark - 解压文件到指定目录,解压成功后删除压缩文件
- (BOOL)unzipFileAtPath:(NSString *)filePath toDestination:(NSString *)destination deleteAfterUnzip:(BOOL)deleteAfterUnzip {
    if (![[MTXFileManager defaultManager] fileExistsAtPath:filePath]) {
        DLog(@"unzipFail:zipFileNotExistsAtPath:%@", filePath);
        [[MTXFileManager defaultManager] createDirectoryAtPath:filePath];
    }
    
    NSError *error = nil;
    BOOL unzipSuccess = [SSZipArchive unzipFileAtPath:filePath toDestination:destination preserveAttributes:YES overwrite:YES password:nil error:&error delegate:self];
    if (error) {
        DLog(@"unzipFail:%@", error.localizedDescription);
    }
    if (unzipSuccess && deleteAfterUnzip) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            DLog(@"removeItemAtPathFailed:%@\nError:%@", filePath, error.localizedDescription);
        }
    }
    return unzipSuccess;
}

#pragma mark - SSZipArchiveDelegate
-(void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo {
}

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {
    DLog(@"UnzipSuccess====zipPath:%@\nunzippedPath:%@", path, unzippedPath);
}

@end
