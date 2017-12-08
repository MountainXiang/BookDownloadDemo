//
//  BookDataBaseManager.h
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/7.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<LKDBHelper.h>)
#import <LKDBHelper.h>
#else
#import "LKDBHelper.h"
#endif

@interface BookDataBaseManager : NSObject

/**
 单例

 @return 实例
 */
+ (instancetype)sharedManager;

/**
 同步插入单条数据 sync insert array ， completed 也是在主线程直接回调的

 @param model 数据模型
 @param block 回调
 */
- (void)insertModelToDB:(NSObject *)model callback:(void(^)(BOOL result))block;

/**
 异步插入单条数据 async insert array ， completed 也是在子线程直接回调的

 @param model 数据模型
 @param block 回调
 */
- (void)insertModelByAsyncToDB:(NSObject *)model callback:(void(^)(BOOL result))block;

/**
 同步插入多条数据 sync insert array ， completed 也是在主线程直接回调的

 @param models 模型数组
 */
- (void)insertArrayToDB:(NSArray *)models;

/**
 同步插入多条数据 sync insert array ， completed 也是在主线程直接回调的

 @param models 模型数组
 @param completedBlock 回调
 */
- (void)insertArrayToDB:(NSArray *)models completed:(void (^)(BOOL allInserted))completedBlock;

/**
 异步插入多条数据 async insert array ， completed 也是在子线程直接回调的

 @param models 模型数组
 */
- (void)insertArrayByAsyncToDB:(NSArray *)models;

/**
 异步插入多条数据

 @param models 模型数组
 @param completedBlock 回调
 */
- (void)insertArrayByAsyncToDB:(NSArray *)models completed:(void (^)(BOOL allInserted))completedBlock;

@end
