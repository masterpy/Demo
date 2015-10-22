//
//  JDDateFormatter.h
//  Demo
//
//  Created by he15his on 15/10/20.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  时间格式化类
 *  时间格式化使用这个单例减少对象创建次数
 */
@interface JDDateFormatter : NSDateFormatter
+ (instancetype)shareInstance;
@end
