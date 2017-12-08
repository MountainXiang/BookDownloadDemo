//
//  BookDataBaseManager.m
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/7.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "BookDataBaseManager.h"
#import "NSObject+LKModel.h"

static NSString * const DBName = @"BookDownload.db";

@interface BookDataBaseManager ()

@property (nonatomic, strong) LKDBHelper *helper;

@end

@implementation BookDataBaseManager

static BookDataBaseManager *manager = nil;

#pragma mark - Singleton pattern
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[BookDataBaseManager alloc] init];
        }
    });
    return manager;
}

#pragma mark - Public Method
- (void)insertModelToDB:(NSObject *)model callback:(void (^)(BOOL))block {
    [self.helper insertToDB:model callback:block];
}

- (void)insertModelByAsyncToDB:(NSObject *)model callback:(void (^)(BOOL))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.helper insertToDB:model callback:block];
    });
}

- (void)insertArrayToDB:(NSArray *)models {
    [self insertArrayToDB:models completed:nil];
}

- (void)insertArrayToDB:(NSArray *)models completed:(void (^)(BOOL))completedBlock {
    [self insertToDBWithArray:models filter:nil completed:completedBlock];
}

- (void)insertArrayByAsyncToDB:(NSArray *)models {
    [self insertArrayByAsyncToDB:models completed:nil];
}

- (void)insertArrayByAsyncToDB:(NSArray *)models completed:(void (^)(BOOL))completedBlock {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self insertToDBWithArray:models filter:nil completed:completedBlock];
    });
}

- (void)insertToDBWithArray:(NSArray *)models filter:(void (^)(id model, BOOL inserted, BOOL *rollback))filter completed:(void (^)(BOOL))completedBlock
{
    __block BOOL allInserted = YES;
    [self.helper executeForTransaction:^BOOL(LKDBHelper *helper) {
        BOOL isRollback = NO;
        for (int i = 0; i < models.count; i++) {
            id obj = [models objectAtIndex:i];
            BOOL inserted = [helper insertToDB:obj];
            allInserted &= inserted;
            if (filter) {
                filter(obj, inserted, &isRollback);
            }
            if (isRollback) {
                allInserted = NO;
                break;
            }
        }
        return (isRollback == NO);
    }];
    
    if (completedBlock) {
        completedBlock(allInserted);
    }
}

#pragma mark - Getter
- (LKDBHelper *)helper {
    if (!_helper) {
        _helper = [[LKDBHelper alloc] initWithDBName:DBName];
    }
    return _helper;
}

@end
