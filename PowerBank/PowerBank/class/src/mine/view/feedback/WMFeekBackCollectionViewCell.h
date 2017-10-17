//
//  WMFeekBackCollectionViewCell.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/13.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WMFeekBackCollectionViewCell;

@protocol WMFeekBackCollectionViewCellDelegate <NSObject>

- (void)deleteImageWithCell:(WMFeekBackCollectionViewCell *)cell;

@end


@interface WMFeekBackCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *feekbackImage;
@property (weak, nonatomic) id<WMFeekBackCollectionViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (assign, nonatomic) NSInteger index;

@end
