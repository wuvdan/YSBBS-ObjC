//
//  CollectedUserTableViewCell.h
//  YSBBSApp
//
//  Created by wudan on 2019/2/14.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectedUserModel : NSObject

@property (nonatomic, assign) NSInteger followUserId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *headPic;

@end

@interface CollectedUserTableViewCell : UITableViewCell
@property (nonatomic, strong) CollectedUserModel *model;
@end

NS_ASSUME_NONNULL_END
