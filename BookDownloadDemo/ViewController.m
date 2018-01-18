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
#import "MTXFileManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    for (NSInteger i = 0; i < 1; i ++) {
        [[BookDownload sharedInstance] downloadBook:[NSString stringWithFormat:@"book_%ld", (long)i]];
    }
    
//    69804558FF954B6691AA22714D263FFF:北极动物来集合
//    5D46BB7762E54116846B04ED6C9F15C8:大灰狼
    NSURLSessionDataTask *task =[DownloadNetworkManager getBookDownloadInfoWithBookGuid:@"69804558FF954B6691AA22714D263FFF" success:^(id  _Nullable data) {

    } failure:^(NSError * _Nullable error) {

    }];
    
//    启动任务
    [task resume];
    
    /*Error：file:///无法定位*/
//    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    //NSURL *targetURL = [[documentsDirectoryURL URLByAppendingPathComponent:@"Book"] URLByAppendingPathComponent:[response suggestedFilename]];
    // 获取沙盒主目录路径
//    NSString *homeDir = NSHomeDirectory();
    // 获取Documents目录路径
//    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    docDir = [docDir stringByAppendingPathComponent:@"test"];
////    NSURL *targetURL = [documentsDirectoryURL URLByAppendingPathComponent:@"test"];
//    [[MTXFileManager defaultManager] createDirectoryAtPath:docDir];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
