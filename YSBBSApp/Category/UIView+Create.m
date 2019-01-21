//
//  UIView+Create.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/24.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "UIView+Create.h"

@implementation UIView (Create)

- (void)addLineInDirection:(UIViewLineDirection)direction lineColor:(UIColor *)aLineColor lineHeight:(CGFloat)aLineHeight {
    
    [self layoutIfNeeded];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = aLineColor;
    
    switch (direction) {
        case UIViewLineDirectionTop:{
            line.frame = CGRectMake(0, 0, self.frame.size.width, aLineHeight);
        }
            break;
        case UIViewLineDirectionLeading:{
            line.frame = CGRectMake(0, 0, aLineHeight, self.frame.size.height);
        }
            break;
        case UIViewLineDirectionTrealing:{
            line.frame = CGRectMake(self.frame.size.width, 0, aLineHeight, self.frame.size.height);
        }
            break;
        case UIViewLineDirectionBottom:{
            line.frame = CGRectMake(0, self.frame.size.width, self.frame.size.width, aLineHeight);
        }
            break;
        default:
            break;
    }
}

@end
