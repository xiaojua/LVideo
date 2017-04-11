//
//  LDownloadViewController.m
//  LVideo
//
//  Created by xiaojuan on 17/4/7.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LDownloadViewController.h"
#import "LDownloadedCell.h"
#import "LDownloadingCell.h"
#import "ZFPlayer.h"
#import "ZFDownloadManager.h"
#import "LPlayerViewController.h"

#define DownloadManager [ZFDownloadManager sharedDownloadManager]

@interface LDownloadViewController ()<UITableViewDelegate, UITableViewDataSource, ZFDownloadDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSMutableArray *downloadObjectArr;
@end

@implementation LDownloadViewController

- (NSMutableArray *)downloadObjectArr {
    if (_downloadObjectArr == nil) {
        _downloadObjectArr = [NSMutableArray array];
    }
    return _downloadObjectArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.tableFooterView = [UIView new];
    NSLog(@"%@",NSHomeDirectory());
    NSLog(@"%@", self.tableView.tableFooterView);
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor redColor];
//    [self.tableView setTableHeaderView:view];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DownloadManager.downloadDelegate = self;
    [self initData];
}
- (void)initData {
    [DownloadManager startLoad];
    /* 对象为ZFFileModel */
    NSMutableArray *finish = DownloadManager.finishedlist;
    /* 对象为ZFHttpRequest */
    NSMutableArray *loading = DownloadManager.downinglist;
    [self.downloadObjectArr addObject:finish];
    [self.downloadObjectArr addObject:loading];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"控制器%@释放了", self.class);
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArr = self.downloadObjectArr[section];
    return sectionArr.count;
//    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LDownloadedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadedCell"];
        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
        cell.fileInfo = fileInfo;
        return cell;
    }else if (indexPath.section == 1) {
        LDownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadingCell"];
        ZFHttpRequest *request = self.downloadObjectArr[indexPath.section][indexPath.row];
        if (!request) {
            return nil;
        }
        ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
        
        // 下载按钮点击时候的要刷新列表
        __weak typeof(self) weakSelf = self;
        cell.btnClickBlock = ^{
            [weakSelf initData];
        };
        
        cell.fileInfo = fileInfo;
        cell.request = request;
        return cell;
    }
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @[@"下载完成", @"下载中"][section];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//删除某行
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
        [DownloadManager deleteFinishFile:fileInfo];
    }else if (indexPath.section == 1) {
        ZFHttpRequest *request = self.downloadObjectArr[indexPath.section][indexPath.row];
        [DownloadManager deleteRequest:request];
    }
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
#pragma mark - action
//全部开始
- (IBAction)startAll:(UIBarButtonItem *)sender {
    [DownloadManager startAllDownloads];
}
//全部暂停
- (IBAction)pauseAll:(UIBarButtonItem *)sender {
    [DownloadManager pauseAllDownloads];
}

#pragma mark - ZFDownloadDelegate
//开始下载
- (void)startDownload:(ZFHttpRequest *)request {
    NSLog(@"开始下载");
}
//下载中
- (void)updateCellProgress:(ZFHttpRequest *)request {
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}
//现在完成
- (void)finishedDownload:(ZFHttpRequest *)request {
    [self initData];
}
//更新下载进度
- (void)updateCellOnMainThread:(ZFFileModel *)fileInfo {
    NSArray *cellArr = [self.tableView visibleCells];
    for (id obj in cellArr) {
        if ([obj isKindOfClass:[LDownloadingCell class]]) {
            LDownloadingCell *cell = (LDownloadingCell *)obj;
            if ([cell.fileInfo.fileURL isEqualToString:fileInfo.fileURL]) {
                cell.fileInfo = fileInfo;
            }
        }
    }
}

#pragma mark - navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
    NSString *filePath = FILE_PATH(fileInfo.fileName);
    NSURL *url = [NSURL fileURLWithPath:filePath];
    LPlayerViewController *pvc = (LPlayerViewController *)segue.destinationViewController;
    pvc.videoURL = url;
}

@end
