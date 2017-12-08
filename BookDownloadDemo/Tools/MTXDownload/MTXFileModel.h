//
//  MTXFileModel.h
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

typedef enum : NSUInteger {
    MTXDownloadStateLoading,//下载中
    MTXDownloadStateWaiting,//等待下载
    MTXDownloadStateSuspend,//暂停下载
}MTXDownloadState;

@interface MTXFileModel : NSObject

/*-------base info-------*/

/**
 文件名
 */
@property (nonatomic, copy) NSString *fileName;

/**
 文件类型
 */
@property (nonatomic, copy) NSString *fileType;

/**
 下载地址
 */
@property (nonatomic, copy) NSString *fileURL;

/**
 文件总大小
 */
@property (nonatomic, assign) double fileSize;

/**
 MD5加密
 */
@property (nonatomic, copy) NSString *MD5;

/**
 缩略图
 */
@property (nonatomic, strong) UIImage *thumbnailImage;

/*-------base info-------*/

/**
 临时文件路径
 */
@property (nonatomic, copy) NSString *tempPath;

/**
 下载速度
 */
@property (nonatomic, assign) double speed;

/**
 开始下载的时间(按照添加时间排序等待)
 */
@property (nonatomic, strong) NSDate *startTime;

/**
 已耗时
 */
@property (nonatomic, assign) NSTimeInterval elapsedTime;

/**
 预计剩余下载时间
 */
@property (nonatomic, assign) NSTimeInterval remainingTime;

/**
 已下载文件大小
 */
@property (nonatomic, assign) double receivedSize;

/**
 已下载的数据
 */
@property (nonatomic, strong) NSMutableData *receivedData;

/**
 下载状态 MTXDownloadState
 MTXDownloadStateLoading,//下载中
 MTXDownloadStateWaiting,//等待下载
 MTXDownloadStateSuspend,//暂停下载
 */
@property (nonatomic, assign) MTXDownloadState state;

/**
 下载错误信息
 */
@property (nonatomic, strong) NSError *error;


@end
