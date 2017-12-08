//
//  BookDownloadInfo.m
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/7.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "BookDownloadInfo.h"
#import "BookDataBaseManager.h"

static NSString * const fileList = @"fileList";
static NSString * const previewPages = @"preViewPages";

@implementation BookDownloadInfo

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:fileList]) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *fileList = value;
            NSMutableArray *resourceInfoArr = [NSMutableArray arrayWithCapacity:fileList.count];
            [fileList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    BookDownloadResourceInfo *info = [[BookDownloadResourceInfo alloc] init];
                    info.bookGuid = _bookGuid;
                    [info setValuesForKeysWithDictionary:obj];
                    info.createTime = [NSString currentTime];
                    info.updateTime = info.createTime;
                    [resourceInfoArr addObject:info];
                    
//                    dispatch_async(dispatch_get_global_queue(0, 0), ^{//异步单条重复插入会造成数据丢失
//                        [[BookDataBaseManager sharedManager] insertModelToDB:info callback:^(BOOL result) {
//                            DLOG(@"====insert====%@====%ld", result ? @"success" : @"fail", (long)info.page);//无序
//                        }];
//                    });
                }
            }];
            
            _resourceInfoArr = [resourceInfoArr copy];
            
            //异步插入，不卡主线程，并且保证插入有序
            [[BookDataBaseManager sharedManager] insertArrayByAsyncToDB:resourceInfoArr completed:^(BOOL allInserted) {
                DLOG(@"====allInserted====%@", allInserted ? @"success" : @"fail");
            }];
        }
    } else if ([key isEqualToString:previewPages]) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *previewPages = value;
            NSMutableArray *previewPageArr = [NSMutableArray arrayWithCapacity:previewPages.count];
            [previewPages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSNumber *number = [NSNumber numberWithInteger:[obj integerValue]];
                [previewPageArr addObject:number];
            }];
            
            _previewPageArr = [previewPageArr copy];
        }
    } else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end

@implementation BookDownloadResourceInfo

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"index"]) {//改变名称，便于数据库存储(字段名称为index 会报语法错误:syntax error)
        _page = [value integerValue];
    } else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
