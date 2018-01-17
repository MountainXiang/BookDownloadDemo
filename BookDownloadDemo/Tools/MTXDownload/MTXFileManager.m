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

@property (nonatomic, strong)NSFileManager *fileManager;

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
    return [self.fileManager fileExistsAtPath:path];
}

- (NSString *)createDirectoryAtPath:(NSString *)path {
    if (![self fileExistsAtPath:path]) {
        // 参数1：创建的文件夹的路径
        // 参数2：是否创建媒介的布尔值，一般为YES
        // 参数3: 属性，没有就置为nil (目录的访问权限和修改时间)
        // 参数4: 错误信息
        NSError *error;
        [self.fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"Create Directory Failure====Error:%@", error.localizedDescription);
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
    NSError *error = nil;
    BOOL unzipSuccess = [SSZipArchive unzipFileAtPath:filePath toDestination:destination preserveAttributes:YES overwrite:YES password:nil error:&error delegate:self];
    if (error) {
        DLog(@"unzipFail:%@", error.localizedDescription);
    }
    return unzipSuccess;
}

#pragma mark - Getter
- (NSFileManager *)fileManager {
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

#pragma mark - SSZipArchiveDelegate
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {
    DLog(@"zipPath:%@\nunzippedPath:%@", path, unzippedPath);
}

@end
