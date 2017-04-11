//
//  LDownloadedCell.h
//  LVideo
//
//  Created by xiaojuan on 17/4/7.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <ZFDownload/ZFDownloadManager.h>
#import "ZFDownloadManager.h"

@interface LDownloadedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;

/* 下载信息模板 */
@property (strong, nonatomic) ZFFileModel *fileInfo;


@end
