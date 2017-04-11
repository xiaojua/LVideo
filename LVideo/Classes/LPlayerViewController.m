//
//  LPlayerViewController.m
//  LVideo
//
//  Created by xiaojuan on 17/4/6.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LPlayerViewController.h"
#import "ZFPlayer.h"
//#import <ZFDownload/ZFDownloadManager.h>
#import "ZFDownloadManager.h"

@interface LPlayerViewController ()<ZFPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIView *playerFatherView;

/* playerView */
@property (strong, nonatomic) ZFPlayerView *playerView;
/* playerModel */
@property (strong, nonatomic) ZFPlayerModel *playerModel;
/** 是否在播放 */
@property (assign, nonatomic) BOOL isPlaying;


@end

@implementation LPlayerViewController

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc]init];
        [_playerView playerControlView:nil playerModel:self.playerModel];
        _playerView.delegate = self;
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload = YES;
        // 打开预览图
        _playerView.hasPreviewView = YES;
        
    }
    return _playerView;
}
- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel = [[ZFPlayerModel alloc]init];
        _playerModel.title = @"playing";
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.videoURL = self.videoURL;
        _playerModel.fatherView = self.playerFatherView;
    }
    return _playerModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.playerView autoPlayTheVideo];
}
- (void)dealloc {
    NSLog(@"控制器%@释放了", self.class);
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    //pop回来的时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        self.playerView.playerPushedOrPresented = NO;
    }
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser) {
        self.isPlaying = YES;
        self.playerView.playerPushedOrPresented = YES;
    }
}

#pragma mark - ZFPlayerDelegate
- (void)zf_playerBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)zf_playerDownload:(NSString *)url {
    NSLog(@"%@", url);
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    NSString *name = [url lastPathComponent];
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
    // 设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 2;
}

#pragma mark - action
- (IBAction)clickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 设置状态栏
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
#pragma mark - 设置旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}



@end
