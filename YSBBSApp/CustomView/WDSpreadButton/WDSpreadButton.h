//
//  WDSpreadButton.h
//  SpreadButton
//
//  Created by 吴丹 on 2018/8/22.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDSpreadButton : UIButton

@property (nonatomic, copy) void (^buttonAction)(NSInteger buttonTag);

@end
