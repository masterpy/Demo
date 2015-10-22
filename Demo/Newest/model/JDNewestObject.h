//
//  NewestObject.h
//  Demo
//
//  Created by he15his on 15/10/20.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

/**
 *  本周精选数据
 */
@interface JDNewestObject : AVObject<AVSubclassing>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSArray *imageUrls;

@end
