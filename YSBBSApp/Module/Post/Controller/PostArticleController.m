//
//  PostArticleController.m
//  YSBBSApp
//
//  Created by wudan on 2018/11/14.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "PostArticleController.h"
#import "PostArticleTextFieldCell.h"
#import "PostArticleTextViewCell.h"
#import "PostArticleToolView.h"
#import "PostArticleImageCollectionViewTableViewCell.h"
#import "WDImagePicker.h"
#import "XG_AssetModel.h"
#import "XG_AssetPickerManager.h"
#import "LZRemindBar.h"
#import "PostArticleNetManager.h"

@interface PostArticleController ()<TextViewCellDelegate,
                                    PostArticleTextFieldCellDelegate>

@property (nonatomic, copy  ) NSString            *titleText;
@property (nonatomic, copy  ) NSString            *contentText;
@property (nonatomic, strong) PostArticleToolView *toolView;
@property (nonatomic, strong) NSMutableArray<XG_AssetModel *> *imageModelArray;
@property (nonatomic, strong) NSMutableArray<UIImage *> *imageArray;
@end

@implementation PostArticleController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self addObserver];
}

// 添加通知监听见键盘弹出/退出
- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -  键盘监听事件
- (void)keyboardAction:(NSNotification*)sender{
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];

    if ([sender.name isEqualToString:UIKeyboardWillShowNotification]) {
        [self.toolView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).inset([value CGRectValue].size.height);
            make.height.mas_equalTo(kRealHeightValue(50));
        }];
    } else {
        [self.toolView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
            make.height.mas_equalTo(kRealHeightValue(50));
        }];
    }
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    [self.wdNavigationBar.centerButton setTitle:@"发帖" forState:UIControlStateNormal];
    [self.wdNavigationBar.rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [self.wdNavigationBar.rightButton setTitleColor:kMainWhite forState:UIControlStateNormal];
    
    kWeakSelf(self)
    self.wdNavigationBar.rightButtonBlock = ^{
        [weakself.view endEditing:true];
        
        if (weakself.titleText.length == 0) {
            [MFHUDManager showError:@"请输入帖子标题"];
            return ;
        }
        
        if (weakself.contentText.length == 0) {
            [MFHUDManager showError:@"请输入帖子内容"];
            return ;
        }
        
        [weakself postTopicWithTitle:weakself.titleText contentText:weakself.contentText];
    };
}

- (void)postTopicWithTitle:(NSString *)title contentText:(NSString *)content {
    
    [[LZRemindBar configurationWithStyle:RemindBarStyleWarn showPosition:RemindBarPositionStatusBar contentText:@"正在上传，请耐心等候"] showBarAfterTimeInterval:1.2];
    
    [self.navigationController popViewControllerAnimated:true];

    /// 发布帖子没有图片的
    if (self.imageModelArray.count == 0) {
        NSDictionary *dic = @{@"title":title,
                              @"content":content};
        
        [[PostArticleNetManager shareInstance] getRequestWithParameterDictionary:dic requsetSuccessBlock:^(id  _Nonnull obj) {
            if (self.publicResultHandler) {
                self.publicResultHandler(true);
            }
        } requsetFailBlock:^(id  _Nonnull obj) {
            [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"发布失败~"] showBarAfterTimeInterval:1.2];
        }];
        
    } else { /// 发布帖子有图片的
        
        dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(serialQueue, ^{
            
            [[PostArticleNetManager shareInstance] multPictureUploadWithImagesArray:[self getImageArray] requsetSuccessBlock:^(id  _Nonnull obj) {
                
                NSArray *imageArray = obj[@"data"];
                
                NSDictionary *dic = @{@"title":title,
                                      @"content":content,
                                      @"img":[NSString stringWithFormat:@"%@",[imageArray componentsJoinedByString:@","]]};
                
                [[PostArticleNetManager shareInstance] getRequestWithParameterDictionary:dic requsetSuccessBlock:^(id  _Nonnull obj) {
                    if (self.publicResultHandler) {
                        self.publicResultHandler(true);
                    }
                } requsetFailBlock:^(id  _Nonnull obj) {
                     [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"发布失败~"] showBarAfterTimeInterval:1.2];
                }];
            } requsetFailBlock:^(id  _Nonnull obj) {
                [[LZRemindBar configurationWithStyle:RemindBarStyleError showPosition:RemindBarPositionStatusBar contentText:@"图片上传失败，请稍后重试~"] showBarAfterTimeInterval:1.2];
            }];
        });
    }
}

- (NSArray<UIImage *> *)getImageArray {
    
    NSMutableArray *array = [NSMutableArray array];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSLog(@"%@", self.imageModelArray);
    
    [self.imageModelArray enumerateObjectsUsingBlock:^(XG_AssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[XG_AssetPickerManager manager] getPhotoWithAsset:obj.asset completion:^(id photo, NSDictionary *info) {
                [array addObject:photo];
                dispatch_semaphore_signal(sema);
            }];
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }];
    
    return array;
}

- (void)setupSubviews {
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[PostArticleTextFieldCell class] forCellReuseIdentifier:@"PostArticleTextFieldCell"];
    [self.tableView registerClass:[PostArticleTextViewCell class] forCellReuseIdentifier:@"PostArticleTextViewCell"];
    [self.tableView registerClass:[PostArticleImageCollectionViewTableViewCell class] forCellReuseIdentifier:@"PostArticleImageCollectionViewTableViewCell"];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)setupSubviewsConstraints {
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.wdNavigationBar.mas_bottom);
        make.leading.trailing.mas_equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view);
        }
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        CGSize size = [[UtilsManager shareInstance] sizeForLblContent:self.contentText fixMaxWidth:(kSCREEN_WIDTH - kRealWidthValue(30)) andFondSize:15];
        CGFloat Height = size.height <= kRealHeightValue(60 + 16) ? kRealHeightValue(60 + 16) : size.height + kRealHeightValue(16);
        return Height;
    }
    
    if (indexPath.section == 2) {
        if (self.imageModelArray.count < 3) {
            return kPOST_ARTICL_IMGAGE_WIDTH;
        } else if (self.imageModelArray.count < 6) {
            return kPOST_ARTICL_IMGAGE_WIDTH * 2 + 10;
        } else {
            return kPOST_ARTICL_IMGAGE_WIDTH * 3 + 20;
        }
    }
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PostArticleTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostArticleTextFieldCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
        
    } else if (indexPath.section == 1) {
        PostArticleTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostArticleTextViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    } else {
        PostArticleImageCollectionViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostArticleImageCollectionViewTableViewCell" forIndexPath:indexPath];
        [cell setCollectionViewTableViewCellRefresh:^(NSArray<XG_AssetModel *> * _Nonnull imageModelArray) {
            self.imageModelArray = [NSMutableArray array];
            [self.imageModelArray addObjectsFromArray:imageModelArray];
            NSLog(@"----%@", self.imageModelArray);
            [tableView reloadData];
        }];
        return cell;
    }
}

#pragma mark - TextViewCellDelegate

- (void)textViewCell:(PostArticleTextViewCell *)cell didChangeText:(NSString *)text {
    self.contentText = text;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark - PostArticleTextFieldCellDelegate

- (void)textChangeInPostArticleTextFieldCell:(PostArticleTextFieldCell *)cell text:(NSString *)text {
    self.titleText = text;
}
@end
