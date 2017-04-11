//
//  LDownloadedCell.m
//  LVideo
//
//  Created by xiaojuan on 17/4/7.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LDownloadedCell.h"

@implementation LDownloadedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFileInfo:(ZFFileModel *)fileInfo {
    _fileInfo = fileInfo;
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    self.fileNameLabel.text = fileInfo.fileName;
    self.fileSizeLabel.text = totalSize;
}



@end
