//
//  LDownloadingCell.h
//  LVideo
//
//  Created by xiaojuan on 17/4/7.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <ZFDownload/ZFDownloadManager.h>
#import "ZFDownloadManager.h"


typedef void(^ZFBtnClickBlock)(void);

@interface LDownloadingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;

/* 下载信息模板 */
@property (strong, nonatomic) ZFFileModel *fileInfo;
/* 下载按钮点击回调block */
@property (copy, nonatomic) ZFBtnClickBlock btnClickBlock;
/* 该文件发起的请求 */
@property (retain, nonatomic) ZFHttpRequest *request;

@end
