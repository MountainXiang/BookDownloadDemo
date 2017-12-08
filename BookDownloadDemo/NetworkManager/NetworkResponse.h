//
//  NetworkResponse.h
//  BookDownloadDemo
//
//  Created by MountainX on 2017/12/7.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkResponse : NSObject

@property (nonatomic, assign)   NSInteger errCode;
@property (nonatomic, copy)     NSString  *errMsg;
@property (nonatomic, readonly) id        body;

- (instancetype)initWithData:(id)data;

@end
