//
//  LCollectionViewCell.h
//  LVideo
//
//  Created by xiaojuan on 17/4/11.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;

/* palyBtn */
@property (strong, nonatomic) UIButton *playBtn;



@end
