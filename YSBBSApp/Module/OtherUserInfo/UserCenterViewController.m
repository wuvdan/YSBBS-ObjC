//
//  UserCenterViewController.m
//  YSBBSApp
//
//  Created by wudan on 2019/2/14.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import "UserCenterViewController.h"
#import "OtherUserInfoModel.h"
#import "OtherUserInfoHeaderView.h"
#import "UserPostModel.h"
#import "UserListArticleImageCell.h"
#import "UserListArticleCell.h"
#import "PostDetailViewController.h"
#import "OtherMorePostViewController.h"

@interface UserCenterViewController () <OtherUserInfoHeaderViewDelegate>

@property (nonatomic, strong) OtherUserInfoModel *model;
@property (nonatomic, strong) OtherUserInfoHeaderView *headerView;
@property (nonatomic, strong) UIView *headerBackView;
@property (nonatomic, strong) UIButton *footerView;

@end

@implementation UserCenterViewController

#define HEAD_HEIGHT (kSCREEN_WIDTH < 375 ? 275 : kSCREEN_WIDTH > 375 ? kRealHeightValue(275) : kRealHeightValue(300))

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    
    self.headerView = [[OtherUserInfoHeaderView alloc] init];
    self.headerView.delegate = self;
    
    self.headerBackView = [[UIView alloc] init];
    self.headerBackView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, HEAD_HEIGHT);
    self.tableView.tableHeaderView = self.headerBackView;
    self.headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, HEAD_HEIGHT);
    [self.headerBackView addSubview:self.headerView];
    
    [[BBSNetworkTool shareInstance] getOtherUserInfoWithUserId:self.userId successBlock:^(id  _Nonnull obj) {
        self.model = [OtherUserInfoModel mj_objectWithKeyValues:obj[@"data"]];
        [self.headerView setupWithModel:self.model];
        [self.tableView reloadData];
        
        if (self.model.topicNum > 5) {
            [self.footerView setTitle:@"加载更多" forState:UIControlStateNormal];
            [self.footerView addTarget:self action:@selector(morePost:) forControlEvents:UIControlEventTouchUpInside];
            self.footerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 45 * kScreenWidthRate);
        } else if (self.model.topicList.count == 0) {
            [self.footerView setTitle:@"暂无任何帖子" forState:UIControlStateNormal];
            self.footerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 45 * kScreenWidthRate);
        } else {
            [self.footerView setTitle:@"" forState:UIControlStateNormal];
            self.footerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 0);
        }
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.wdNavigationBar.mas_bottom);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view);
        }
    }];
    
    self.footerView = [[UIButton alloc] init];
    [self.footerView setTitle:@"暂无任何帖子" forState:UIControlStateNormal];
    [self.footerView setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
    self.footerView.titleLabel.font = [UIFont systemFontOfSize:13];
    self.footerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 45 * kScreenWidthRate);
    self.tableView.tableFooterView = self.footerView;
}

- (void)morePost:(id)sender {
    OtherMorePostViewController *vc = [[OtherMorePostViewController alloc] init];
    vc.userId = self.userId;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    CGFloat viewHeight = HEAD_HEIGHT;
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset < 0) {
        CGFloat totalOffset = viewHeight + ABS(yOffset);
        CGFloat f = totalOffset / viewHeight;
        self.headerView.frame = CGRectMake(- (width * f - width) / 2, yOffset, width * f, totalOffset);
    }
    
    if (yOffset > HEAD_HEIGHT) {
        [self.wdNavigationBar.centerButton setTitle:self.model.nickname forState:UIControlStateNormal];
    } else {
        [self.wdNavigationBar.centerButton setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)followActionWithModel:(OtherUserInfoModel *)model {
    if (model.isFollow) {
        [[BBSNetworkTool shareInstance] unfollowUserWithUserId:model.id successBlock:^(id  _Nonnull obj) {
            
        }];
    } else {
        [[BBSNetworkTool shareInstance] followUserWithUserId:model.id successBlock:^(id  _Nonnull obj) {
            
        }];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.topicList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? kRealHeightValue(8) : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserPostModel *model = self.model.topicList[indexPath.section];
    
    if ([model getStyle] == PostCellStyleOnlyText) {
        NSString *identifier = @"UserListArticleCell";
        UserListArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"UserListArticleCell" owner:self options:nil].firstObject;
        }
        cell.model = model;
        return cell;
        
    } else {
        NSString *identifier = @"UserListArticleImageCell";
        UserListArticleImageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"UserListArticleImageCell" owner:self options:nil].firstObject;
        }
        cell.model = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PostDetailViewController *controller = [[PostDetailViewController alloc] init];
    UserPostModel *model = self.model.topicList[indexPath.section];
    controller.topicId = model.id;
    [self.navigationController pushViewController:controller animated:true];
}

@end
