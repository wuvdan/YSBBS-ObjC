//
//  UtilsManager.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/24.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "UtilsManager.h"
#import "WDTextView.h"
#import "NSDate+date.h"

@interface UtilsManager ()

/** 缓存文件夹路径属性 */
@property (nonatomic, copy) NSString * fileCachePath;

@end

@implementation UtilsManager

static UtilsManager *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+ (instancetype)shareInstance {
    return  [[self alloc] init];
}

#pragma mark  快速创建TextFiled 
- (WDInputView *)createInputViewWithPlaceholder:(NSString *)aPlaceholder maxLength:(NSInteger)aMaxLength leftIconName:(NSString *)aleftIconName keyboardAppearance:(UIKeyboardAppearance)aKeyboardAppearance keyboardType:(UIKeyboardType)aKeyboardType {
    
    WDInputView *view = [[WDInputView alloc] init];
    view.placeholder = aPlaceholder;
    view.maxLength = aMaxLength;
    view.errorStr = @"超出字数限制";
    view.leftIconName = aleftIconName;
    view.lineSelectedColor = kMainWhite;
    view.remindTextColor = kMainWhite;
    view.textLengthLabelColor = kMainWhite;
    view.textColor = kMainWhite;
    view.textField.keyboardAppearance = aKeyboardAppearance;
    view.textField.keyboardType = aKeyboardType;
    [view.textField setValue:kMainWhite forKeyPath:@"_placeholderLabel.textColor"];
   
    return view;
}

#pragma mark  登录账号密码检测 
- (void)loginLimtWithAcount:(NSString *)account password:(NSString *)aPassword showSuccess:(nonnull void (^)(void))aShowSuccess {
    
    if (account.length == 0) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请输入账号名称"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    if (aPassword.length == 0) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请输入登录密码"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    aShowSuccess();
}

#pragma mark  注册邮箱检测 
- (void)registerCheckEmial:(NSString *)anEmail showSuccess:(void(^)(void))aShowSuccess {
    
    if (anEmail.length == 0) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请输入邮箱"] showBarAfterTimeInterval:1.2];
        return;
    }
    
    NSString *emailPr = @"^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z0-9]{2,6}$";
    NSPredicate *predEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailPr];
    BOOL isMatchEmial = [predEmail evaluateWithObject:anEmail];
    if (!isMatchEmial) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"邮箱的格式错误"] showBarAfterTimeInterval:1.2];
        return;
    }
    
    aShowSuccess();
}

#pragma mark  注册输入检测 
- (void)registerLimtWithAcount:(NSString *)account emailString:(NSString *)email emailCode:(NSString *)anEmailCode password:(NSString *)aPassword  againPassword:(NSString *)aAgainPassword  showSuccess:(nonnull void (^)(void))aShowSuccess{
    
    if (account.length == 0) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请输入账号名称"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    if (account.length < 6 ) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"账号长度不能小于6位"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    if (account.length > 16 ) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"账号长度不能大于16位"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    NSString *accountPr = @"^[a-z0-9_-]{0,16}$";
    NSPredicate *predAccount = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", accountPr];
    BOOL isMatchAcc = [predAccount evaluateWithObject:account];
    if (!isMatchAcc) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"账号只能是数字和小写字母组合"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    
    if (email.length == 0) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请输入邮箱"] showBarAfterTimeInterval:1.2];
        return;
    }
    
    NSString *emailPr = @"^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z0-9]{2,6}$";
    NSPredicate *predEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailPr];
    BOOL isMatchEmial = [predEmail evaluateWithObject:email];
    if (!isMatchEmial) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"邮箱的格式错误"] showBarAfterTimeInterval:1.2];
        return;
    }
    
    if (anEmailCode.length == 0) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请输入验证码"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    if (anEmailCode.length != 6) {
         [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请输入验证码格式错误"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    if (aPassword.length == 0) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请输入登录密码"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    if (aPassword.length < 6 ) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"密码长度不能小于6位"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    if (aPassword.length > 16 ) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"密码长度不能大于16位"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    NSString *password = @"^[0-9A-Za-z]{0,16}$";
    NSPredicate *predPwd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", password];
    BOOL isMatchPwd = [predPwd evaluateWithObject:aPassword];
    if (!isMatchPwd) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"密码只能是数字和字母组合"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    if (aAgainPassword.length == 0) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请再次输入密码"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    if (![aPassword isEqualToString:aAgainPassword]) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"两次输入的密码不一致"] showBarAfterTimeInterval:1.2];
        return ;
    }

    aShowSuccess();
}

#pragma mark  修改密码输入检测 
- (void)modifyPassowordLimtWitholdPassword:(NSString *)oldPassowrd password:(NSString *)aPassword  againPassword:(NSString *)aAgainPassword  showSuccess:(nonnull void (^)(void))aShowSuccess {
    
    if (oldPassowrd.length == 0) {
         [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请输入原密码"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    if (aPassword.length == 0) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请输入登录密码"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    if (aPassword.length < 6 ) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"密码长度不能小于6位"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    if (aPassword.length > 16 ) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"密码长度不能大于16位"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    NSString *password = @"^[0-9A-Za-z]{0,16}$";
    NSPredicate *predPwd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", password];
    BOOL isMatchPwd = [predPwd evaluateWithObject:aPassword];
    if (!isMatchPwd) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"密码只能是数字和字母组合"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    if (aAgainPassword.length == 0) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请再次输入密码"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    if (![aPassword isEqualToString:aAgainPassword]) {
         [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"两次输入的密码不一致"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    aShowSuccess();
}


#pragma mark  忘记密码输入检测 
- (void)forgetPasswordCheckWithEmial:(NSString *)anEmial emailCode:(NSString *)anEmialCode password:(NSString *)aPassword  againPassword:(NSString *)againPassword showSuccess:(nonnull void (^)(void))aShowSuccess {
    
    if (anEmial.length == 0) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请输入邮箱地址"] showBarAfterTimeInterval:1.2];
        return;
    }
    
    NSString *emailPr = @"^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z0-9]{2,6}$";
    NSPredicate *predEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailPr];
    BOOL isMatchEmial = [predEmail evaluateWithObject:anEmial];
    if (!isMatchEmial) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"邮箱的格式错误"] showBarAfterTimeInterval:1.2];
        return;
    }
    
    if (anEmialCode.length == 0) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请输入验证码"] showBarAfterTimeInterval:1.2];
        return;
    }
    
    if (anEmialCode.length != 6) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请输入验证码格式错误"] showBarAfterTimeInterval:1.2];
        return;
    }
    
    NSString *password = @"^[0-9A-Za-z]{0,16}$";
    NSPredicate *predPwd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", password];
    BOOL isMatchPwd = [predPwd evaluateWithObject:aPassword];
    if (!isMatchPwd) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"密码必须是数字和字母组合"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    if (againPassword.length == 0) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"请再次输入密码"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    if (![aPassword isEqualToString:againPassword]) {
        [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"两次输入的密码不一致"] showBarAfterTimeInterval:1.2];
        return ;
    }
    
    aShowSuccess();
}

#pragma mark  设置字体 
- (UIFont *)createSytemFontSize:(CGFloat)fonySize fontName:(NSString *)aName {
    if (aName.length == 0) {
         return [UIFont fontWithName:@"Zapfino" size:fonySize * UIScreen.mainScreen.bounds.size.width/375.0];
    }
     return [UIFont fontWithName:aName size:fonySize * UIScreen.mainScreen.bounds.size.width/375.0];
}

#pragma mark  获取缓存大小 
- (CGFloat)getCacheSize {
    
    CGFloat folderSize = 0.0;
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    for (NSString *path in files) {
        NSString*filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        folderSize += [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    CGFloat sizeM = folderSize /1024.0/1024.0;
    return sizeM;
}

#pragma mark  清理缓存 
- (void)cleanCache {
    NSString*cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    NSArray*files = [[NSFileManager defaultManager]subpathsAtPath:cachePath];
    for (NSString *p in files) {
        NSError*error;
        NSString*path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
            BOOL isRemove = [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
            if (isRemove) {
                NSLogInfo(@"清除成功");
            } else {
                NSLogError(@"清除失败");
            }
        }
    }
}

#pragma mark  快速创建WDTextView 
- (WDTextView *)textViewPlaceholder:(NSString *)aPlaceholder {
    WDTextView *textView = [[WDTextView alloc] init];
    textView.font = kFont(15);
    textView.cornerRadius = 0;
    textView.placeholderColor = kMainGrey;
    textView.placeholderFont = kFont(15);
    textView.placeholder = aPlaceholder;
    return textView;
}

#pragma mark  九宫格布局 
- (void)wd_masLayoutSubViewsWithViewArray:(NSArray<UIView *> *)viewArray
                              columnOfRow:(NSInteger)column
                    topBottomOfItemSpeace:(CGFloat)tbSpeace
                      leftRightItemSpeace:(CGFloat)lrSpeace
                     topOfSuperViewSpeace:(CGFloat)topSpeace
                 leftRightSuperViewSpeace:(CGFloat)lrSuperViewSpeace
                          addToSubperView:(UIView *)superView
                               viewHeight:(CGFloat)viewHeight{
    
    CGFloat viewWidth = kSCREEN_WIDTH - kRealWidthValue(30);
    CGFloat itemWidth = (viewWidth - lrSuperViewSpeace * 2 - (column - 1) * lrSpeace) / column * 1.0f;
    CGFloat itemHeight = viewHeight;
    UIView *last = nil;
    
    for (int i = 0; i < viewArray.count; i++) {
        UIView *item = viewArray[i];
        [superView addSubview:item];
        
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(itemWidth);
            make.height.mas_equalTo(itemHeight);
            CGFloat top = topSpeace + (i / column) * (itemHeight + tbSpeace);
            make.top.mas_offset(top);
            if (!last || (i % column) == 0) {
                make.left.mas_offset(lrSuperViewSpeace);
            }else{
                make.left.mas_equalTo(last.mas_right).mas_offset(lrSpeace);
            }
        }];
        last = item;
    }
}

#pragma mark  传入一个timeStr，返回对应格式的字符串
- (NSString *)setupCreateTime:(NSString *)timeStr {
    
    // NSDateFormatter:NSString与NSDate互转
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    // 设置格式
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 发布日期对象
    NSDate *createDate = [fmt dateFromString:timeStr];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *cmp = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute  fromDate:createDate toDate:[NSDate date] options:NSCalendarWrapComponents];
    
    if ([createDate isThisYear]) {
        if ([createDate isThisToday]) {
            
            // 获取日期差值
            if (cmp.hour >= 1) {
                timeStr = [NSString stringWithFormat:@"%ld小时前",cmp.hour];
            } else if (cmp.minute >= 2) {
                timeStr = [NSString stringWithFormat:@"%ld分钟前",cmp.minute];
            } else { // 刚刚
                timeStr = @"刚刚";
            }
            
        } else if ([createDate isThisYesterday]) { // 昨天
            // 昨天 21:10
            fmt.dateFormat = @"昨天 HH:mm";
            timeStr = [fmt stringFromDate:createDate];
            
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd";
            timeStr = [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd";
        timeStr = [fmt stringFromDate:createDate];
    }
    
    return timeStr;
}

#pragma mark - 计算文字高度
- (CGSize)sizeForLblContent:(NSString *)strContent fixMaxWidth:(CGFloat)w andFondSize:(int)fontSize {
    UIFont *font          = [UIFont systemFontOfSize:fontSize];
    NSDictionary *dicAttr = [[NSDictionary alloc] initWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [strContent boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicAttr context:nil].size;
    return size;
}

@end
