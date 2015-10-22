//
//  JDAddCasusTableViewController.m
//  Demo
//
//  Created by he15his on 15/10/22.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import "JDAddCasusTableViewController.h"
#import "JDNewestObject.h"
#import <SVProgressHUD.h>
#import "TQStarRatingView.h"

@interface JDAddCasusTableViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//Views
@property (weak, nonatomic) IBOutlet UIButton *photoButton1;
@property (weak, nonatomic) IBOutlet UIButton *photoButton2;
@property (weak, nonatomic) IBOutlet UIButton *photoButton3;

@property (weak, nonatomic) IBOutlet UIView *textFieldBackgroundView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *scoreBackgroundView;

@property (weak, nonatomic) IBOutlet TQStarRatingView *originalityStarView;
@property (weak, nonatomic) IBOutlet TQStarRatingView *visionStarView;
@property (weak, nonatomic) IBOutlet TQStarRatingView *technologyStarView;

@property (weak, nonatomic) IBOutlet UIButton *completeButton;

//Data
@property (nonatomic, strong) UIImage *addImage;
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation JDAddCasusTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置cell中子view的初始属性
    [self adjustCellSubViews];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        [self addPhotoWithImage:image];
    }

    [picker dismissViewControllerAnimated: YES completion: nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Event Handle

- (IBAction)photoButtonClicked:(UIButton *)sender {
    if (sender == self.photoButton1) {
        if (self.images.count == 0) {
            [self showPhotoSelectAlertView];
        }
    }else if (sender == self.photoButton2) {
        if (self.images.count == 1) {
            [self showPhotoSelectAlertView];
        }
    }else {
        if (self.images.count == 2) {
            [self showPhotoSelectAlertView];
        }
    }
}

- (IBAction)completeButtonClicked:(UIButton *)sender {
    if (![self shouldSendToNetwork]) {
        return;
    }
    
    //创建同步串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    NSMutableArray *imageUrls = [NSMutableArray arrayWithCapacity:1];
    [SVProgressHUD show];

    for (NSInteger i = 0; i < self.images.count; i++) {
        dispatch_sync(serialQueue, ^{
            NSData *imageData = UIImageJPEGRepresentation(self.images[i], 0.5);
            AVFile *file = [AVFile fileWithData:imageData];
            NSError *error;
            [file save:&error];
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.domain];
            }else {
                [imageUrls addObject:file.url];
            }
        });
    }

    if (imageUrls.count > 0) {
        JDNewestObject *object = [JDNewestObject object];
        object.title = self.titleTextField.text;
        object.content = self.contentTextView.text;
        //TODO: 分数应该不是这样算的，现简单写个算的方法，不单独存每一个的值
        CGFloat score = (self.originalityStarView.score + self.visionStarView.score + self.technologyStarView.score) * 100 / 3;
        object.score = score;
        object.imageUrls = imageUrls;
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.domain];
            }else {
                //发送成功返回上级页面
                [SVProgressHUD dismiss];
                !self.addSuccessBlock ?: self.addSuccessBlock(object);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (IBAction)labelButtonClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

#pragma mark - Private Method

- (void)adjustCellSubViews {
    self.textFieldBackgroundView.layer.masksToBounds = YES;
    self.textFieldBackgroundView.layer.cornerRadius = 3;
    self.textFieldBackgroundView.layer.borderWidth = 1;
    self.textFieldBackgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.contentTextView.layer.masksToBounds = YES;
    self.contentTextView.layer.cornerRadius = 3;
    self.contentTextView.layer.borderWidth = 1;
    self.contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
    
    self.scoreBackgroundView.layer.borderWidth = 1;
    self.scoreBackgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.originalityStarView setScore:0.2 withAnimation:NO];
    [self.visionStarView setScore:0.2 withAnimation:NO];
    [self.technologyStarView setScore:0.2 withAnimation:NO];
    
    self.completeButton.layer.masksToBounds = YES;
    self.completeButton.layer.cornerRadius = 3;
    self.completeButton.layer.borderWidth = 1;
    self.completeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;

    [self.photoButton1 setImage:self.addImage forState:UIControlStateNormal];
    self.photoButton2.hidden = YES;
    self.photoButton3.hidden = YES;
}

- (void)showPhotoSelectAlertView{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerVC.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        pickerVC.delegate = self;
        [self presentViewController: pickerVC animated: YES completion: nil];
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerVC.delegate = self;
        [self presentViewController: pickerVC animated: YES completion: nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addPhotoWithImage:(UIImage *)image {
    
    if (self.images.count == 0) {
        [self.photoButton1 setImage:image forState:UIControlStateNormal];
        self.photoButton2.hidden = NO;
        [self.photoButton2 setImage:self.addImage forState:UIControlStateNormal];
    }else if (self.images.count == 1) {
        [self.photoButton2 setImage:image forState:UIControlStateNormal];
        self.photoButton3.hidden = NO;
        [self.photoButton3 setImage:self.addImage forState:UIControlStateNormal];

    }else {
        [self.photoButton3 setImage:image forState:UIControlStateNormal];
    }
    [self.images addObject:image];
}

- (BOOL)shouldSendToNetwork {
    if (self.images.count < 1) {
        [SVProgressHUD showErrorWithStatus:@"图片不能为空"];
        return NO;
    }
    if (self.titleTextField.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"标题不能为空"];
        return NO;
    }
    if (self.contentTextView.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"描述不能为空"];
        return NO;
    }
    return YES;
}

#pragma mark - Getter

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray arrayWithCapacity:0];
    }
    return _images;
}

- (UIImage *)addImage {
    if (!_addImage) {
        _addImage = [UIImage imageNamed:@"add_photo"];
    }
    return _addImage;
}
@end
