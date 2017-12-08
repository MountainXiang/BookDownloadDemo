//
//  ViewController.m
//  BookDownloadDemo
//
//  Created by MountainX on 2017/11/23.
//  Copyright © 2017年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "ViewController.h"
#import "BookDownload.h"
#import "DownloadNetworkManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    for (NSInteger i = 0; i < 10; i ++) {
        [[BookDownload sharedInstance] downloadBook:[NSString stringWithFormat:@"book_%ld", (long)i]];
    }
    
    NSURLSessionDataTask *task =[DownloadNetworkManager getBookDownloadInfoWithBookGuid:@"5D46BB7762E54116846B04ED6C9F15C8" success:^(id  _Nullable data) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
    
    //启动任务
    [task resume];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
