//
//  CollectedViewController.m
//  YSBBSApp
//
//  Created by wudan on 2019/2/14.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import "CollectedViewController.h"
#import "UserPostModel.h"
#import "PostArticleController.h"
#import "PostDetailViewController.h"
#import "UserListArticleImageCell.h"
#import "UserListArticleCell.h"

@interface CollectedViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) double totalElements;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) FCXRefreshHeaderView *refreshHeaderView;
@property (nonatomic, strong) FCXRefreshFooterView *refreshFooterView;
@end

@implementation CollectedViewController


#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    self.totalElements = 0;
    [self getListOfUserPostWithPageNo:self.pageNo];
}

#pragma mark - SetupSubviewsUI
- (void)setupSubviews{
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    
    self.refreshFooterView = [self.tableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        if (weakSelf.totalElements/10.0 > (weakSelf.pageNo*1.0)) {
            weakSelf.pageNo ++;
            [weakSelf getListOfUserPostWithPageNo:weakSelf.pageNo];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.refreshFooterView endRefresh];
            });
        }
    }];
    
    self.refreshHeaderView = [self.tableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        weakSelf.pageNo = 1;
        [weakSelf getListOfUserPostWithPageNo:weakSelf.pageNo];
    }];
    
    [self.wdNavigationBar.centerButton setTitle:@"我的收藏" forState:UIControlStateNormal];
}

#pragma mark - SetupSubviewsConstraints
- (void)setupSubviewsConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.wdNavigationBar.mas_bottom);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view);
        }
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserPostModel *model = self.modelArray[indexPath.section];
    
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
    UserPostModel *model = self.modelArray[indexPath.section];
    controller.topicId = model.id;
    controller.deletePost = ^{
        self.pageNo = 1;
        [self getListOfUserPostWithPageNo:self.pageNo];
    };
    [self.navigationController pushViewController:controller animated:true];
}

#pragma mark  DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"empty"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:@"您还没有收藏任何帖子..." attributes:@{NSForegroundColorAttributeName:kMainGrey,NSFontAttributeName:kFont(15)}];
    return att;
}

#pragma mark  NetWork Request
- (void)getListOfUserPostWithPageNo:(NSInteger)pageNo {
    
    [[BBSNetworkTool shareInstance] getCollectionListPostPageSize:@"10" pageNo:pageNo successBlock:^(id  _Nonnull obj) {
        if (pageNo == 1) {
            self.modelArray = [NSMutableArray array];
            for (NSDictionary *dic in obj[@"data"][@"list"]) {
                UserPostModel *model = [UserPostModel mj_objectWithKeyValues:dic];
                [self.modelArray addObject:model];
            }
            [self.refreshHeaderView endRefresh];
        } else {
            for (NSDictionary *dic in obj[@"data"][@"list"]) {
                UserPostModel *model = [UserPostModel mj_objectWithKeyValues:dic];
                [self.modelArray addObject:model];
            }
            [self.refreshFooterView endRefresh];
        }
        self.totalElements = [obj[@"data"][@"totalElements"] doubleValue];
        [self.tableView reloadData];
    }];
}

@end
