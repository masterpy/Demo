//
//  NewestPhotoView.m
//  Demo
//
//  Created by he15his on 15/10/20.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import "JDNewestPhotoView.h"
#import "JDNewestObject.h"
#import <UIImageView+WebCache.h>

@interface JDNewestPhotoView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@end

@implementation JDNewestPhotoView

- (void)configViewDataWithObject:(JDNewestObject *)object {
    self.imageView1.hidden = YES;
    self.imageView2.hidden = YES;
    self.imageView3.hidden = YES;
    
    for (NSInteger i = 0; i < object.imageUrls.count; i++) {
        NSString *imageUrlString = object.imageUrls[i];
        if (i == 0) {
            [self setImageView:self.imageView1 url:imageUrlString];
        }else if (i == 1) {
            [self setImageView:self.imageView2 url:imageUrlString];
        }else {
            [self setImageView:self.imageView3 url:imageUrlString];
        }
    }
}

- (void)setImageView:(UIImageView *)imageView url:(NSString *)url {
    imageView.hidden = NO;
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
}
@end
