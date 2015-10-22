//
//  NewestTableViewCell.h
//  Demo
//
//  Created by he15his on 15/10/20.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JDNewestObject;

/**
 *  本周精选Cell
 */
@interface JDNewestTableViewCell : UITableViewCell

- (void)configCellDataWithObject:(JDNewestObject *)object showDate:(BOOL)showDate;
@end
