//
//  BookDownloadInfo.h
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/7.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BookDownloadResourceInfo;

@interface BookDownloadInfo : NSObject

/*-----------便于联表查询-----------*/
@property (nonatomic, copy)   NSString *bookGuid;

@property (nonatomic, copy)   NSString *createTime;

@property (nonatomic, copy)   NSString *updateTime;
/*-----------便于联表查询-----------*/

@property (nonatomic, strong) NSArray <BookDownloadResourceInfo *> * resourceInfoArr;

@property (nonatomic, strong) NSArray <NSNumber *> *previewPageArr;

@end

typedef enum : NSUInteger {
    BookResourceTypeNormal = 1,//普通资源
    BookResourceTypeStore,//资源商店
} BookResourceType;

@interface BookDownloadResourceInfo : NSObject

/*-----------便于联表查询-----------*/
@property (nonatomic, copy)   NSString *bookGuid;

@property (nonatomic, copy)   NSString *createTime;

@property (nonatomic, copy)   NSString *updateTime;
/*-----------便于联表查询-----------*/

@property (nonatomic, assign)    NSInteger page;

@property (nonatomic, copy)      NSString* fileName;

@property (nonatomic, copy)      NSString* fileMD5;

@property (nonatomic, assign)    double fileSize;

@property (nonatomic, assign)    BookResourceType fileType;

@end
