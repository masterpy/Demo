//
//  NewestPhotoView.h
//  Demo
//
//  Created by he15his on 15/10/20.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDNewestObject;

/**
 *  本周精选页图片显示view
 */
@interface JDNewestPhotoView : UIView

- (void)configViewDataWithObject:(JDNewestObject *)object;
@end
