//
//  PostArticleTextViewCell.m
//  YSBBSApp
//
//  Created by wudan on 2018/11/14.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "PostArticleTextViewCell.h"
#import "UITextView+Placeholder.h"

@interface PostArticleTextViewCell () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation PostArticleTextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupConstants];
    }
    return self;
}

- (void)setupUI {
    self.textView               = [[UITextView alloc] init];
    self.textView.delegate      = self;
    self.textView.scrollEnabled = false;
    self.textView.font          = [UIFont systemFontOfSize:15];
    [self.textView wd_setPlaceholderWithText:@"输入帖子的内容" Color:kRGBA(0, 0, 0.0980392, 0.22)];
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.isAutoHeightEnable = true;
    [self.contentView addSubview:self.textView];
}

- (void)setupConstants {
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(kRealWidthValue(15));
        make.top.bottom.mas_equalTo(self.contentView).inset(kRealHeightValue(8));
        make.height.mas_equalTo(kRealHeightValue(60));
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    
   CGSize size = [[UtilsManager shareInstance] sizeForLblContent:textView.text fixMaxWidth:(kSCREEN_WIDTH - kRealWidthValue(30)) andFondSize:15];
    CGFloat Height = size.height <= kRealHeightValue(60) ? kRealHeightValue(60) : size.height;
    
    if ([self.delegate respondsToSelector:@selector(textViewCell:didChangeText:)]) {
        [self.delegate textViewCell:self didChangeText:textView.text];
        
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.height.mas_equalTo(Height);
        }];
        [self.textView.superview updateConstraintsIfNeeded];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
