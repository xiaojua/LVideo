//
//  LDownloadingCell.m
//  LVideo
//
//  Created by xiaojuan on 17/4/7.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LDownloadingCell.h"


@implementation LDownloadingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickDownload:(UIButton *)sender {
    // 执行操作过程中应该禁止该按键的响应 否则会引起异常
    sender.userInteractionEnabled = NO;
    ZFFileModel *downFile = self.fileInfo;
    ZFDownloadManager *downloadManager = [ZFDownloadManager sharedDownloadManager];
    if (downFile.downloadState == ZFDownloading) {
        self.downLoadBtn.selected = YES;
        [downloadManager stopRequest:self.request];
    }else {
        self.downLoadBtn.selected = NO;
        [downloadManager resumeRequest:self.request];
    }
    
    // 暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
    sender.userInteractionEnabled = YES;
}

- (void)setFileInfo:(ZFFileModel *)fileInfo {
    _fileInfo = fileInfo;
    self.fileNameLabel.text = fileInfo.fileName;
    // 服务器可能响应的慢，拿不到视频总长度 && 不是下载状态
    if ([fileInfo.fileSize longLongValue] == 0 && !(fileInfo.downloadState == ZFDownloading)) {
        self.progressLabel.text = @"";
        if (fileInfo.downloadState == ZFStopDownload) {
            self.speedLabel.text = @"已暂停";
        }else if (fileInfo.downloadState == ZFWillDownload) {
            self.speedLabel.text = @"等待下载";
            self.downLoadBtn.selected = YES;
        }
        self.progress.progress = 0;
        return;
    }
    NSString *currentSize = [ZFCommonHelper getFileSizeString:fileInfo.fileReceivedSize];
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    float progress = (float)[fileInfo.fileReceivedSize longLongValue] / [fileInfo.fileSize longLongValue];
    self.progress.progress = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%@ / %@ (%.2f%%)", currentSize, totalSize, progress*100];
    
    if (fileInfo.speed) {
        NSString *speed = [NSString stringWithFormat:@"%@ 剩余%@", fileInfo.speed, fileInfo.remainingTime];
        self.speedLabel.text = speed;
    }else{
        self.speedLabel.text = @"正在获取";
    }
    
    if (fileInfo.downloadState == ZFDownloading) {
        self.downLoadBtn.selected = NO;
    }else if (fileInfo.downloadState == ZFStopDownload && !fileInfo.error) {
        self.downLoadBtn.selected = YES;
        self.speedLabel.text = @"已暂停";
    }else if (fileInfo.downloadState == ZFWillDownload && !fileInfo.error) {
        self.downLoadBtn.selected = YES;
        self.speedLabel.text = @"等待下载";
    }else if (fileInfo.error) {
        self.downLoadBtn.selected = YES;
        self.speedLabel.text = @"错误";
    }
    
    
}


@end
