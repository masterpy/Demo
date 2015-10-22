//
//  JDSelectLabelButton.m
//  Demo
//
//  Created by he15his on 15/10/22.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import "JDSelectLabelButton.h"

@implementation JDSelectLabelButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self adjustView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self adjustView];
    }
    return self;
}

- (void)adjustView {
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.layer.borderColor = [UIColor redColor].CGColor;
    }else {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}
@end
