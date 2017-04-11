//
//  LVideoViewController.m
//  LVideo
//
//  Created by xiaojuan on 17/4/6.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LVideoViewController.h"
#import "LPlayerViewController.h"


@interface LVideoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/* data */
@property (copy, nonatomic) NSArray *dataArr;

@end

@implementation LVideoViewController

- (NSArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = @[@"http://7xqhmn.media1.z0.glb.clouddn.com/femorning-20161106.mp4",
                     @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4",
                     @"http://baobab.wdjcdn.com/1456117847747a_x264.mp4",
                     @"http://baobab.wdjcdn.com/14525705791193.mp4",
                     @"http://baobab.wdjcdn.com/1456459181808howtoloseweight_x264.mp4",
                     @"http://baobab.wdjcdn.com/1455968234865481297704.mp4",
                     @"http://baobab.wdjcdn.com/1455782903700jy.mp4",
                     @"http://baobab.wdjcdn.com/14564977406580.mp4",
                     @"http://baobab.wdjcdn.com/1456316686552The.mp4",
                     @"http://baobab.wdjcdn.com/1456480115661mtl.mp4",
                     @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4",
                     @"http://baobab.wdjcdn.com/1455614108256t(2).mp4",
                     @"http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4",
                     @"http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4",
                     @"http://baobab.wdjcdn.com/1456734464766B(13).mp4",
                     @"http://baobab.wdjcdn.com/1456653443902B.mp4",
                     @"http://baobab.wdjcdn.com/1456231710844S(24).mp4"];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.statusBarStyle = UIStatusBarStyleLightContent;
}
#pragma mark - tableDelegate,datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableVideoCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"video%ld", indexPath.row+1];
    cell.backgroundColor = [UIColor grayColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 必须支持转屏，但只是只支持竖屏，否则横屏启动起来页面是横的
- (BOOL)shouldAutorotate {
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LPlayerViewController *player = (LPlayerViewController *)segue.destinationViewController;
    UITableViewCell *cell = (UITableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSURL *url = [NSURL URLWithString:self.dataArr[indexPath.row]];
    player.videoURL = url;
}


@end
