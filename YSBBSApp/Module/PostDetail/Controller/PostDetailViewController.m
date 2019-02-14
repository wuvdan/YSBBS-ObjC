//
//  PostDetailViewController.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/28.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "PostDetailViewController.h"
#import "PostDetailModel.h"
#import "PostCommentToolView.h"
#import "CommentModel.h"
#import "CommentTableViewCell.h"
#import "PostArticleDetailCell.h"
#import "UserPostModel.h"
#import "WDPageViewController.h"
#import "UserCenterViewController.h"

@interface PostDetailViewController () <UITextViewDelegate,
                                        CommentTableViewCellLikeDelegate,
                                        LZAlterViewDelegate,
                                        DZNEmptyDataSetSource,
                                        DZNEmptyDataSetDelegate,
                                        PostArticleDetailCellDelegate>

@property (nonatomic, strong) PostCommentToolView *commentToolView;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) double totalElements;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) FCXRefreshHeaderView *refreshHeaderView;
@property (nonatomic, strong) FCXRefreshFooterView *refreshFooterView;
@property (nonatomic, strong) PostDetailModel *detailModel;

@end

@implementation PostDetailViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark  LifeCyle 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    self.textHeight = 0;
    [self getPostDetail];
    [self getCommtList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardAction:(NSNotification*)sender {
        
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    if ([sender.name isEqualToString:UIKeyboardWillShowNotification]) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.commentToolView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.mas_equalTo(self.view);
                if (@available(iOS 11.0, *)) {
                    make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).inset([value CGRectValue].size.height);
                } else {
                    make.bottom.mas_equalTo(self.view).inset([value CGRectValue].size.height);
                }
                make.height.mas_equalTo(kRealHeightValue(50));
            }];
            [self.commentToolView.superview layoutIfNeeded];
        }];        
    } else if ([sender.name isEqualToString:UIKeyboardWillHideNotification]) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.commentToolView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.mas_equalTo(self.view);
                if (@available(iOS 11.0, *)) {
                    make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                } else {
                    make.bottom.mas_equalTo(self.view);
                }
                make.height.mas_equalTo(kRealHeightValue(50));
            }];
            [self.commentToolView.superview layoutIfNeeded];
        }];
    } else {
        
    }
}


#pragma mark  提示删帖 
- (void)deletePostData {
    kWeakSelf(self)
    
    UIImage *image = [[UIImage imageNamed:@"删除"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.wdNavigationBar.rightButton setImage:image forState:UIControlStateNormal];
    self.wdNavigationBar.rightTwoButton.imageView.tintColor = UIColor.whiteColor;
    
    self.wdNavigationBar.rightButtonBlock = ^{
        [[[[LZAlterView alter] configureWithActionTitleArray:@[@"确定删帖？"]
                                           cancelActionTitle:@"取消"] setupDelegate:weakself] showAlter];
    };
}

#pragma mark - 收藏帖子
- (void)collectionPost {
    UIImage *image = [[UIImage imageNamed:@"收藏"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    if (self.detailModel.isMy) {
        [self.wdNavigationBar.rightTwoButton setImage:image forState:UIControlStateNormal];
        self.wdNavigationBar.rightTwoButton.imageView.tintColor = UIColor.whiteColor;
        
        if (self.detailModel.isCollection) {
            self.wdNavigationBar.rightTwoButton.imageView.tintColor = kMainLightGreen;
        } else {
            self.wdNavigationBar.rightTwoButton.imageView.tintColor = UIColor.whiteColor;
        }
        
        kWeakSelf(self)
        self.wdNavigationBar.rightTwoButtonBlock = ^{
            kRStrongSelf(self)
            if (self.detailModel.isCollection) {
                [[BBSNetworkTool shareInstance] unCollectPostWithId:self.detailModel.id successBlock:^(id  _Nonnull obj) {
                    self.wdNavigationBar.rightTwoButton.imageView.tintColor = UIColor.whiteColor;
                }];
            } else {
                [[BBSNetworkTool shareInstance] collectPostWithId:self.detailModel.id successBlock:^(id  _Nonnull obj) {
                    self.wdNavigationBar.rightTwoButton.imageView.tintColor = kMainLightGreen;
                }];
            }
        };
    } else {
        [self.wdNavigationBar.rightButton setImage:image forState:UIControlStateNormal];
        if (self.detailModel.isCollection) {
            self.wdNavigationBar.rightButton.imageView.tintColor = kMainLightGreen;
        } else {
            self.wdNavigationBar.rightButton.imageView.tintColor = UIColor.whiteColor;
        }
        
        kWeakSelf(self)
        self.wdNavigationBar.rightButtonBlock = ^{
            kRStrongSelf(self)
            if (self.detailModel.isCollection) {
                [[BBSNetworkTool shareInstance] unCollectPostWithId:self.detailModel.id successBlock:^(id  _Nonnull obj) {
                    self.wdNavigationBar.rightButton.imageView.tintColor = UIColor.whiteColor;
                }];
            } else {
                [[BBSNetworkTool shareInstance] collectPostWithId:self.detailModel.id successBlock:^(id  _Nonnull obj) {
                    self.wdNavigationBar.rightButton.imageView.tintColor = kMainLightGreen;
                }];
            }
        };
    }
}

- (void)alterView:(LZAlterView *)alterView didSelectedAtIndex:(NSInteger)index {
        
    [[BBSNetworkTool shareInstance] deletePostWithTopicId:self.topicId successBlock:^(id  _Nonnull obj) {
        [self.navigationController popViewControllerAnimated:true];
        if (self.deletePost) {
            self.deletePost();
        }
    }];
}

#pragma mark  网络请求——>获取帖子详情 
- (void)getPostDetail {
    [[BBSNetworkTool shareInstance] postDetailWithTopicId:self.topicId successBlock:^(id  _Nonnull obj) {
        PostDetailModel *model = [PostDetailModel mj_objectWithKeyValues:obj[@"data"]];
        self.detailModel = model;
        self.commentToolView.likeNumButton.tintColor = model.isLike ? kMainDarkGreen : kMainWhite;
        [self.tableView reloadData];
        if (model.isMy) {
            [self deletePostData];
        }
        
        if (model.isCollection) {
            self.wdNavigationBar.rightTwoButton.imageView.tintColor = kMainLightGreen;
        } else {
            self.wdNavigationBar.rightTwoButton.imageView.tintColor = UIColor.whiteColor;
        }
        
        [self collectionPost];
    }];
}

#pragma mark  网络请求——>获取评论列表 
- (void)getCommtList {
    [[BBSNetworkTool shareInstance] commentListWithTopicId:self.topicId pageSize:@"10" pageNo:self.pageNo successBlock:^(id  _Nonnull obj) {
        if (self.pageNo == 1) {
             [[DataBaseTools manager] clearDataFromTableName:CommentListTable];
            for (NSDictionary *dic in obj[@"data"][@"list"]) {
                CommentModel *model = [CommentModel mj_objectWithKeyValues:dic];
                [[DataBaseTools manager] insertDataWithTableName:CommentListTable model:model successBlock:^{
                    
                } failBlock:^{
                    
                }];
            }
            [self readFromFMDB];
            [self.refreshHeaderView endRefresh];
        } else {
            for (NSDictionary *dic in obj[@"data"][@"list"]) {
                CommentModel *model = [CommentModel mj_objectWithKeyValues:dic];
                [[DataBaseTools manager] insertDataWithTableName:CommentListTable model:model successBlock:^{
                    
                } failBlock:^{
                    
                }];
            }
            [self readFromFMDB];
            [self.refreshFooterView endRefresh];
        }
        
        [self.tableView reloadData];
    }];
}
- (void)readFromFMDB {
    self.modelArray = [NSMutableArray array];
    for (UserPostModel *model in [[DataBaseTools manager] queryAllDataWithTableName:CommentListTable]) {
        [self.modelArray addObject:model];
        NSLog(@"%ld", (long)model.id);
    }
}

#pragma mark  SetupNavigationBar 
- (void)setupNavigationBar{
    [super setupNavigationBar];
    [self.wdNavigationBar.centerButton setTitle:@"详情" forState:UIControlStateNormal];
}

#pragma mark  SetupSubviewsUI 
- (void)setupSubviews{
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self.view addSubview:self.tableView];
    
    self.commentToolView = [[PostCommentToolView alloc] init];
    self.commentToolView.textView.delegate = self;
    
    
    [self.commentToolView.textView textValueDidChanged:^(NSString * _Nonnull text, CGFloat textHeight) {
        self.textHeight = textHeight;
        if (text.length > 100) {
            [[LZRemindBar configurationWithStyle:RemindBarStyleWarn showPosition:RemindBarPositionStatusBar contentText:@"评论最大只能是100个字符"] showBarAfterTimeInterval:1.2];            
            return;
        }
        
        [self.commentToolView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.height.mas_equalTo(textHeight + kRealHeightValue(20));
        }];
    }];
    
    [self refreshData];
    
    
    [self.commentToolView.likeNumButton addTarget:self action:@selector(likeNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentToolView.publicButton addTarget:self action:@selector(publicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.commentToolView];
    
    UILabel *label = [[UILabel alloc] initWithText:@"这是最底下了，没有数据了~" textColor:UIColor.lightGrayColor textFont:13 textAlignment:NSTextAlignmentCenter];
    label.frame = CGRectMake(0, 0, Screen_Width, 30);
    self.tableView.tableFooterView = label;
}

#pragma mark  SetupSubviewsConstraints 
- (void)setupSubviewsConstraints{
    
    [self.commentToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(kRealHeightValue(50));
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view);
        }
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.commentToolView.mas_top);
        make.top.mas_equalTo(self.wdNavigationBar.mas_bottom);
    }];
}

#pragma mark  上拉下拉刷新 
- (void)refreshData {
    kWeakSelf(self);
    self.refreshHeaderView = [self.tableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        weakself.pageNo = 1;
        [weakself getCommtList];
    }];
    
    self.refreshFooterView = [self.tableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        if (weakself.totalElements/10.0 > (weakself.pageNo*1.0)) {
            weakself.pageNo ++;
            [weakself getCommtList];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.refreshFooterView endRefresh];
            });
        }
    }];
}

#pragma mark  按钮点击事件 
- (void)likeNumButtonAction:(UIButton *)sender {

    if ([sender.tintColor isEqual:kMainWhite] ) {
        sender.tintColor = kMainDarkGreen;
        [[BBSNetworkTool shareInstance] likePostWithTopicId:self.topicId successBlock:^(id  _Nonnull obj) {
            
        }];
    } else {
        sender.tintColor = kMainWhite;
        [[BBSNetworkTool shareInstance] cancelLikePostWithTopicId:self.topicId successBlock:^(id  _Nonnull obj) {
            
        }];
    }
}

-(void)publicButtonAction:(id)sender {
    if (self.commentToolView.textView.text.length == 0) {
        return;
    }
    
    [[BBSNetworkTool shareInstance] commentPostWithContent:self.commentToolView.textView.text topicId:self.topicId successBlock:^(id  _Nonnull obj) {
        self.commentToolView.textView.text = @"";
        [self getCommtList];
        [self.view endEditing:true];
    }];
}

#pragma mark  UITableViewDelegate && UITableViewDataSource 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.modelArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    UILabel *label = [[UILabel alloc] initWithText:@"评论列表" textColor:kMainBlack textFont:15 textAlignment:NSTextAlignmentLeft];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.leading.mas_equalTo(view).inset(kRealWidthValue(15));
    }];
    return section == 0 ? nil : view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
     return section == 0 ? 0 : kRealHeightValue(40);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        PostArticleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostDetailHeaderCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"PostArticleDetailCell" owner:self options:nil].firstObject;
        }
        cell.delegate = self;
        if (self.model) {
            cell.userPostModel = self.model;
        } else {
            cell.model = self.detailModel;
        }        
        return cell;
    } else {
        NSString * const reuserIdentify = [NSString stringWithFormat:@"commentcell%ld",(long)indexPath.row];
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentify];
        if (cell == nil) {
            cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentify];
        }
        cell.delegate = self;
        cell.model = self.modelArray[indexPath.row];
        return cell;
    }
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
    if (self.modelArray.count > 0) {
        CommentModel *model = self.modelArray[indexPath.row];
        return model.isMy ? YES : NO;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    CommentModel *model = self.modelArray[indexPath.row];

    [[BBSNetworkTool shareInstance] deleteCommentWithCommentId:model.id successBlock:^(id  _Nonnull obj) {
        
    }];
    
    [self.modelArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:1]] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)userInfoWithModel:(UserPostModel *)model {
    if (model.isMy) {
        WDPageViewController *vc = [[WDPageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    } else {
        UserCenterViewController *vc = [[UserCenterViewController alloc] init];
        vc.userId = model.userId;
        [self.navigationController pushViewController:vc animated:true];
    }
}

#pragma mark  DZNEmptyDataSetSource 
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"empty"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:@"暂时还没有任何评论..." attributes:@{NSForegroundColorAttributeName:kMainGrey,NSFontAttributeName:kFont(15)}];
    return att;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return self.tableView.tableHeaderView.frame.size.height;
}

#pragma mark  UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:true];
}

#pragma mark  CommentTableViewCellLikeDelegate 
- (void)likeCommentWithModel:(CommentModel *)model {
    
    model.isLike = !model.isLike;
    
    [[DataBaseTools manager] likeFromTableName:CommentListTable model:model id:model.wd_fmdb_id successBlock:^{
        if (model.isLike) {
            [[BBSNetworkTool shareInstance] likeCommentWithCommentId:model.id successBlock:^(id  _Nonnull obj) {
                
            }];
        } else {
            [[BBSNetworkTool shareInstance] cancelLikeCommentWithCommentId:model.id successBlock:^(id  _Nonnull obj) {
                
            }];
        }
    } failBlock:^{
        
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        [[BBSNetworkTool shareInstance] commentPostWithContent:self.commentToolView.textView.text topicId:self.topicId successBlock:^(id  _Nonnull obj) {
            self.commentToolView.textView.text = @"";
            [self getCommtList];
        }];
        
        return NO;
    }
    return YES;
}

@end
