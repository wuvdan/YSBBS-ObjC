//
//  LZSystemSDKManager.m
//  YSBBSApp
//
//  Created by wudan on 2019/1/25.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import "LZSystemSDKManager.h"
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>


#define kRootViewController  UIApplication.sharedApplication.delegate.window.rootViewController

@interface LZSystemSDKManager () <  CNContactPickerDelegate,
MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate,
CLLocationManagerDelegate>

@property (nonatomic, copy) void (^selectContactResult)(CNContact *obj) API_AVAILABLE(ios(9.0));
@property (nonatomic, copy) void (^postEmailResult)(NSInteger obj);
@property (nonatomic, copy) void (^sendMessageResult)(NSInteger obj);
@property (nonatomic, copy) void (^locakResult)(id info);
@end

@implementation LZSystemSDKManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static LZSystemSDKManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[LZSystemSDKManager alloc] init];
    });
    return manager;
}

#pragma mark - 选择联系人信息
- (void)lz_selecteContactResulet:(void(^)(CNContact *obj))result API_AVAILABLE(ios(9.0)) {
    self.selectContactResult = result;
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (error) {
                [self showHUDTitle:@"未获取访问权限" info:@"请前往设置中打开访问权限"];
            } else {
                CNContactPickerViewController * picker = [CNContactPickerViewController new];
                picker.delegate = self;
                picker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
                [kRootViewController presentViewController: picker  animated:YES completion:nil];
            }
        }];
    }
    
    if (status == CNAuthorizationStatusAuthorized) {
        CNContactPickerViewController * picker = [CNContactPickerViewController new];
        picker.delegate = self;
        picker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        [kRootViewController presentViewController: picker  animated:YES completion:nil];
    }
    else{
        [self showHUDTitle:@"未获取访问权限" info:@"请前往设置中打开访问权限"];
    }
}

#pragma mark - CNContactPickerDelegate
-  (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty API_AVAILABLE(ios(9.0)) {
    CNContact *contact = contactProperty.contact;
    self.selectContactResult(contact);
}

#pragma mark - 发送邮件
- (void)lz_postEmialWithToRecipients:(NSArray<NSString *> *)toRecipients
                        ccRecipients:(NSArray<NSString *> *)ccRecipients
                       bccRecipients:(NSArray<NSString *> *)bccRecipients
                               theme:(NSString *)theme
                        emailContent:(NSString *)emailContent
                              isHTML:(BOOL)isHTML
                               reslt:(nonnull void (^)(NSInteger))result {
    
    self.postEmailResult = result;
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    mailCompose.mailComposeDelegate = self;
    [mailCompose setToRecipients:toRecipients];
    [mailCompose setCcRecipients:ccRecipients];
    [mailCompose setBccRecipients:bccRecipients];
    [mailCompose setSubject:theme];
    [mailCompose setMessageBody:emailContent isHTML:isHTML];
    [kRootViewController presentViewController:mailCompose animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate的代理方法：
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
    self.postEmailResult(result);
}


#pragma mark - 发送短信
- (void)lz_sendMessageWithToRecipients:(NSArray<NSString *> *)toRecipients content:(NSString *)content reslt:(nonnull void (^)(NSInteger))result {
    self.sendMessageResult = result;
    MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
    messageVC.recipients = toRecipients;
    messageVC.body = content;
    messageVC.messageComposeDelegate = self;
    [kRootViewController presentViewController:messageVC animated:YES completion:nil];
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:true completion:nil];
    self.sendMessageResult(result);
}

#pragma mark - 拨号
- (void)lz_dailPhone:(NSString *)phoneNum {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]]];
}

#pragma mark - 定位服务
- (void)lz_openLocationService:(void(^)(id info))localResult {
    self.locakResult = localResult;
    CLLocationManager *localManager = [[CLLocationManager alloc] init];
    localManager.delegate = self;
    localManager.desiredAccuracy = kCLLocationAccuracyBest;
    localManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    [localManager requestWhenInUseAuthorization];
    
    if ([CLLocationManager locationServicesEnabled] ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        
        [localManager startUpdatingLocation];
    } else {
        [self showHUDTitle:@"未获取定位权限" info:@"请前往设置中打开定位权限"];
    }
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *currLocation = [locations lastObject];
    CLLocation *infLocation = [[CLLocation alloc] initWithLatitude:currLocation.coordinate.latitude longitude:currLocation.coordinate.longitude];
    
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:infLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error !=nil || placemarks.count == 0) {
            NSLog(@"%@",error);
            self.locakResult(nil);
            return ;
        }
        
        NSDictionary *infoDic = @{@"country":placemarks.firstObject.country,
                                  @"administrativeArea":placemarks.firstObject.administrativeArea,
                                  @"locality":placemarks.firstObject.locality,
                                  @"subLocality":placemarks.firstObject.subLocality,
                                  @"thoroughfare":placemarks.firstObject.thoroughfare,
                                  @"name":placemarks.firstObject.name
                                  };
        self.locakResult(infoDic);
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self showHUDTitle:@"未获取定位权限" info:@"请前往设置中打开定位权限"];
}

#pragma mark - 提示框
- (void)showHUDTitle:(NSString *)title info:(NSString *)info {
    
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:title message:info
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancal = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                
            }
        }
    }];
    
    [alterController addAction:cancal];
    [alterController addAction:sure];
    
    [kRootViewController presentViewController:alterController animated:true completion:nil];
}

#pragma mark - IOS 10前的通知
- (void)lz_pushNotifationWithTimeInterval:(NSTimeInterval)timeInterval
                           repeatInterval:(NSInteger)repeatInterval
                                alertBody:(NSString *)alertBody
                               alertTitle:(NSString *)alertTitle
                              alertAction:(NSString *)alertAction
                         alertLaunchImage:(NSString *)alertLaunchImage
                                soundName:(NSString *)soundName
                                 userInfo:(NSDictionary *)userInfo {
    // 定义本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置调用时间
    notification.timeZone = [NSTimeZone localTimeZone];
    //通知触发的时间，10s以后
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
    // 通知重复次数
    notification.repeatInterval = repeatInterval;
    // 当前日历，使用前最好设置时区等信息以便能够自动同步时间
    notification.repeatCalendar = [NSCalendar currentCalendar];
    
    //设置通知属性
    // 通知主体
    notification.alertBody = alertBody;
    if (@available(iOS 8.2, *)) {
        notification.alertTitle = alertTitle;
    } else {
        // Fallback on earlier versions
    }
    // 应用程序图标右上角显示的消息数
    notification.applicationIconBadgeNumber += 1;
    // 待机界面的滑动动作提示
    notification.alertAction = alertAction;
    // 通过点击通知打开应用时的启动图片,这里使用程序启动图片
    notification.alertLaunchImage = alertLaunchImage;
    // 收到通知时播放的声音，默认消息声音
    notification.soundName = soundName.length == 0 ? UILocalNotificationDefaultSoundName : soundName;
    
    //设置用户信息
    notification.userInfo = userInfo;
    
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - IOS 10的通知
-(void)lz_pushNotification_IOS_10_Title:(NSString *)title
                               subtitle:(NSString *)subtitle
                                   body:(NSString *)body
                             promptTone:(NSString *)promptTone
                              soundName:(NSString *)soundName
                              imageName:(NSString *)imageName
                              movieName:(NSString *)movieName
                           timeInterval:(NSTimeInterval)TimeInterval
                                repeats:(BOOL)repeats
                             Identifier:(NSString *)identifier API_AVAILABLE(ios(10.0)) {
    
    //获取通知中心用来激活新建的通知
    UNUserNotificationCenter * center  = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subtitle;
    content.body = body;
    
    //通知的提示音
    if ([promptTone containsString:@"."]) {
        UNNotificationSound *sound = [UNNotificationSound soundNamed:promptTone];
        content.sound = sound;
    } else {
        UNNotificationSound *sound = [UNNotificationSound defaultSound];
        content.sound = sound;
    }
    
    __block UNNotificationAttachment *imageAtt;
    __block UNNotificationAttachment *movieAtt;
    __block UNNotificationAttachment *soundAtt;
    
    if ([imageName containsString:@"."]) {
        [self addNotificationAttachmentContent:content attachmentName:imageName options:nil withCompletion:^(NSError *error, UNNotificationAttachment *notificationAtt) {
            imageAtt = [notificationAtt copy];
        }];
    }
    
    if ([soundName containsString:@"."]) {
        [self addNotificationAttachmentContent:content attachmentName:soundName options:nil withCompletion:^(NSError *error, UNNotificationAttachment *notificationAtt) {
            soundAtt = [notificationAtt copy];
        }];
    }
    
    if ([movieName containsString:@"."]) {
        // 在这里截取视频的第10s为视频的缩略图 ：UNNotificationAttachmentOptionsThumbnailTimeKey
        [self addNotificationAttachmentContent:content attachmentName:movieName options:@{@"UNNotificationAttachmentOptionsThumbnailTimeKey":@10} withCompletion:^(NSError *error, UNNotificationAttachment *notificationAtt) {
            movieAtt = [notificationAtt copy];
        }];
    }
    
    NSMutableArray * array = [NSMutableArray array];
    
    if (imageAtt) {
        [array addObject:imageAtt];
    }
    
    if (soundAtt) {
        [array addObject:soundAtt];
    }
    
    if (movieAtt) {
        [array addObject:movieAtt];
    }
    
    content.attachments = array;
    
    //添加通知下拉动作按钮
    NSMutableArray * actionMutableArray = [NSMutableArray array];
    UNNotificationAction * actionA = [UNNotificationAction actionWithIdentifier:@"identifierNeedUnlock" title:@"进入应用" options:UNNotificationActionOptionAuthenticationRequired];
    UNNotificationAction * actionB = [UNNotificationAction actionWithIdentifier:@"identifierRed" title:@"忽略" options:UNNotificationActionOptionDestructive];
    [actionMutableArray addObjectsFromArray:@[actionA,actionB]];
    
    if (actionMutableArray.count > 1) {
        UNNotificationCategory * category = [UNNotificationCategory categoryWithIdentifier:@"categoryNoOperationAction" actions:actionMutableArray intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        [center setNotificationCategories:[NSSet setWithObjects:category, nil]];
        content.categoryIdentifier = @"categoryNoOperationAction";
    }
    
    // UNTimeIntervalNotificationTrigger   延时推送
    // UNCalendarNotificationTrigger       定时推送
    // UNLocationNotificationTrigger       位置变化推送
    BOOL repeat = (TimeInterval > 60 && repeats) ? true : false;
    UNTimeIntervalNotificationTrigger * tirgger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:TimeInterval repeats:repeat];
    
    //建立通知请求
    UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:tirgger];
    
    // 将建立的通知请求添加到通知中心
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@本地推送 :( 报错 %@",identifier, error);
        } else {
            NSLog(@"成功");
        }
    }];
}


/**
 增加通知附件
 
 @param content 通知内容
 @param attachmentName 附件名称
 @param options 相关选项
 @param completion 结果回调
 */
-(void)addNotificationAttachmentContent:(UNMutableNotificationContent *)content attachmentName:(NSString *)attachmentName  options:(NSDictionary *)options withCompletion:(void(^)(NSError * error , UNNotificationAttachment * notificationAtt))completion  API_AVAILABLE(ios(10.0)) {
    
    NSArray * arr = [attachmentName componentsSeparatedByString:@"."];
    
    NSError * error;
    
    NSString * path = [[NSBundle mainBundle]pathForResource:arr[0] ofType:arr[1]];
    if (path) {
        UNNotificationAttachment * attachment = [UNNotificationAttachment attachmentWithIdentifier:[NSString stringWithFormat:@"notificationAtt_%@",arr[1]] URL:[NSURL fileURLWithPath:path] options:options error:&error];
        
        if (error) {
            NSLog(@"attachment error %@", error);
        }
         completion(error,attachment);
    }
   
   
    content.launchImageName = attachmentName;
}
@end
