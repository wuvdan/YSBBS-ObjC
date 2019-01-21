//
//  UIImage+Addition.h
//  iOSLearn-Objc
//
//  Created by wudan on 2018/10/25.
//  Copyright © 2018 wudan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到小
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};

@interface UIImage (Addition)


/**
 渐变色
 
 @param colors 颜色数组
 @param gradientType 方向
 @param imgSize 尺寸
 @return return value description
 */
+ (UIImage *)lz_gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;

/**
 用颜色返回一张图片
 
 @param color 颜色
 @return return value description
 */
- (nullable UIImage *)lz_imageWithColor:(UIColor *)color;

/**
 用颜色返回一张图片（指定图片大小）
 
 @param color 颜色
 @param size 大小
 @return return value description
 */
- (nullable UIImage *)lz_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 为UIImage添加滤镜效果
 
 @param filter 滤镜名称
 @return return value description
 */
- (nullable UIImage *)lz_addFilter:(NSString *)filter;

/**
 设置图片的透明度
 
 @param alpha 透明度
 @return return value description
 */
- (nullable UIImage *)lz_alpha:(CGFloat)alpha;

/**
 图片模糊效果
 
 @return return value description
 */
- (UIImage *)lz_blur;

/**
 在图片上加居中的文字
 
 @param title 显示文字
 @param fontSize 字体大小
 @param titleColor 颜色
 @return return value description
 */
- (UIImage *)lz_imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor;

/**
 取图片某一像素点的颜色
 
 @param point 图片上的某一点
 @return 图片上这一点的颜色
 */
- (UIColor *)lz_colorAtPixel:(CGPoint)point;

/**
 获得灰度图
 
 @return return value description
 */
- (UIImage *)lz_convertToGrayImage;

/**
 加载Gif图片
 
 @param theData data
 @return return value description
 */
- (UIImage *)lz_animatedImageWithAnimatedGIFData:(NSData *)theData;

/**
 加载Gif图片
 
 @param theURL url地址
 @return return value description
 */
- (UIImage *)lz_animatedImageWithAnimatedGIFURL:(NSURL *)theURL;

/**
 合并两个图片为一个图片
 
 @param firstImage 图片一
 @param secondImage 图片二
 @return return value description
 */
- (UIImage*)lz_mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;

/**
 纠正图片的方向
 
 @return return value description
 */
- (UIImage *)lz_fixOrientation;

/**
 按给定的方向旋转图片
 
 @param orient 方向
 @return return value description
 */
- (UIImage*)lz_rotate:(UIImageOrientation)orient;

/**
 将图片旋转degrees角度
 
 @param degrees 角度
 @return return value description
 */
- (UIImage *)lz_imageRotatedByDegrees:(CGFloat)degrees;

/**
 将图片旋转radians弧度
 
 @param radians 弧度
 @return return value description
 */
- (UIImage *)lz_imageRotatedByRadians:(CGFloat)radians;

/**
 压缩图片
 
 @param maxLength 最大字节大小为maxLength
 @return return value description
 */
- (NSData *)lz_compressWithMaxLength:(NSInteger)maxLength;

/**
 压缩图片至指定尺寸
 
 @param size 尺寸
 @return return value description
 */
- (UIImage *)lz_rescaleImageToSize:(CGSize)size;

/**
 压缩图片至指定像素
 
 @param toPX 像素
 @return return value description
 */
- (UIImage *)lz_rescaleImageToPX:(CGFloat )toPX;

/**
 UIView转化为UIImage
 
 @param view view
 @return return value description
 */
- (UIImage *)lz_imageFromView:(UIView *)view;

/**
 设置圆角图片
 
 @param radius 圆角半径
 @return return value description
 */
- (UIImage *)lz_imageByRoundCornerRadius:(CGFloat)radius;

/**
 *  设置圆角图片
 *
 *  @param radius 圆角半径
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
- (nullable UIImage *)lz_imageByRoundCornerRadius:(CGFloat)radius
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor;

/**
 根据image的data 判断图片类型
 
 @param data 图片data
 @return 图片类型(png、jpg...)
 */
+ (NSString *)contentTypeWithImageData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
