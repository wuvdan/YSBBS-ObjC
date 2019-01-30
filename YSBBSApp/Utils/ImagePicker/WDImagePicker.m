//
//  WDImagePicker.m
//  IntelligenceHome
//
//  Created by Vincent Yang on 2018/4/27.
//  Copyright © 2018年 xlz.foreve.love. All rights reserved.
//

#import "WDImagePicker.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "LZAlterView.h"

const float kScaleHeadImageHeights = 500.0f;

@interface WDImagePicker()<
                          UIActionSheetDelegate,
                          UINavigationControllerDelegate,
                          UIImagePickerControllerDelegate,
                          LZAlterViewDelegate
                          >
@property (nonatomic, strong) UIViewController *vc;
@property(nonatomic, copy) PickerCompletion comp;
@end

static WDImagePicker *imagePicker = nil;

@implementation WDImagePicker

+(instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        if (!imagePicker) {
            imagePicker = [WDImagePicker new];
        }
    });
    return imagePicker;
}

-(void)startWithVC:(UIViewController *)vc {
    _vc = vc;

    NSArray *array = @[@"拍照", @"从相册获取"];
    
    [[[[LZAlterView alter] configureWithActionTitleArray:array cancelActionTitle:@"取消"] setupDelegate:self] showAlter];
}

- (void)alterView:(LZAlterView *)alterView didSelectedAtIndex:(NSInteger)index {
    if (index == 0) {
        [self p_takePhotoFromCamera];
    } else {
        [self p_takePhotoFromPhotoLibrary];
    }
}

-(void)setPickerCompletion:(PickerCompletion)comp{
    _comp = comp;
}

- (void)p_takePhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        imagePicker.delegate = self;
        imagePicker.title  = @"拍照";
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        [_vc presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)p_takePhotoFromPhotoLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        imagePicker.delegate = self;
        imagePicker.title  = @"选择照片";
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage, (NSString *)kUTTypeGIF];
        [_vc presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^()
     {
     //此处选择为原始图片，若需要裁剪，可用 UIImagePickerControllerEditedImage
     UIImage* image = info[UIImagePickerControllerOriginalImage];
         dispatch_async(dispatch_get_main_queue(), ^{
             if (self.comp) {
                 self.comp(weakSelf,nil,image);
             }
         });
     }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.comp) {
            NSString * description = @"";
            if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                description = @"用户已取消选择照片！";
            }else{
                description = @"用户已取消拍照！";
            }
            NSError * error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:1 userInfo:@{@"description":description}];
            self.comp(weakSelf,error,nil);
        }
    });
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage*)imageScaleAspectFit:(UIImage *)image toSize:(CGSize)se
{
    UIGraphicsBeginImageContextWithOptions(se, YES, 1.0);
    
    CGSize imgSe=image.size;
    
    if (imgSe.width/se.width<imgSe.height/se.height) {
        
        [image drawInRect:CGRectMake((se.width-se.height*imgSe.width/imgSe.height)*0.5f,
                                     0.0f,
                                     se.height*imgSe.width/imgSe.height,
                                     se.height)];
    }else{
        [image drawInRect:CGRectMake(0,
                                     (se.height-se.width*imgSe.height/imgSe.width)*0.5f,
                                     se.width,
                                     se.width*imgSe.height/imgSe.width)];
    }
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
