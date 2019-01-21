//
//  HomeViewController.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/25.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "HomeViewController.h"
#import "WDSpreadButton.h"
#import "PostArticleController.h"
#import "UserInfoViewController.h"
#import "UserPostModel.h"
#import "PostDetailViewController.h"
#import "ArticleTableViewCell.h"
#import "WDPageViewController.h"


@interface HomeViewController ()<ArticleTableViewCellDelegate,
                                DZNEmptyDataSetSource,
                                DZNEmptyDataSetDelegate,
                                UIViewControllerPreviewingDelegate>

@property (nonatomic, assign) NSInteger            pageNo;
@property (nonatomic, assign) double               totalElements;
@property (nonatomic, strong) NSMutableArray       *modelArray;
@property (nonatomic, strong) FCXRefreshHeaderView *refreshHeaderView;
@property (nonatomic, strong) FCXRefreshFooterView *refreshFooterView;
@property (nonatomic, strong) WDSpreadButton *spreadButton;

@end

@implementation HomeViewController

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo        = 1;
    self.totalElements = 0;
    [self getListOfUserPostWithPageNo:self.pageNo];

    [self readFromFMDB];
    
    if (self.needPushToPostArticleController) {
        PostArticleController *controller = [[PostArticleController alloc] init];
        controller.publicResultHandler = ^(BOOL isSuccess) {
            self.pageNo = 1;
            [self getListOfUserPostWithPageNo:self.pageNo];
        };
        [self.navigationController pushViewController:controller animated:true];
    }
}

#pragma mark - SetupNavigationBar
- (void)setupNavigationBar{
    [super setupNavigationBar];
    self.wdNavigationBar.backgroundColor = kMainBlack;
    [self.wdNavigationBar.centerButton setTitle:@"首页" forState:UIControlStateNormal];
    [self.wdNavigationBar.centerButton setTitleColor:kMainWhite forState:UIControlStateNormal];
    self.wdNavigationBar.leftButton.hidden = true;
}

#pragma mark - SetupSubviewsUI
- (void)setupSubviews{
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    [self refreshData];
    
    self.spreadButton = [[WDSpreadButton alloc] init];
    [self.view addSubview:self.spreadButton];
    [self spreadButtonAction];
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
    
    self.spreadButton.frame = CGRectMake(kRealWidthValue(15),
                                         UIScreen.mainScreen.bounds.size.height-kRealWidthValue(55),
                                         kRealWidthValue(40),
                                         kRealWidthValue(40));
}

#pragma mark - 按钮点击事件
- (void)spreadButtonAction {
    kWeakSelf(self)
    self.spreadButton.buttonAction = ^(NSInteger buttonTag) {
        if (buttonTag == 10) {
            WDPageViewController *controller = [[WDPageViewController alloc] init];
            [weakself pushControllerWithController:controller];
        } else {
            PostArticleController *controller = [[PostArticleController alloc] init];
            controller.publicResultHandler = ^(BOOL isSuccess) {
                weakself.pageNo = 1;
                [weakself getListOfUserPostWithPageNo:weakself.pageNo];
            };
            [weakself pushControllerWithController:controller];
        }
    };
}

#pragma mark - 数据刷新
- (void)refreshData {
    kWeakSelf(self)
    self.refreshHeaderView = [self.tableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        weakself.pageNo = 1;
        [weakself getListOfUserPostWithPageNo:weakself.pageNo];
    }];
    
    self.refreshFooterView = [self.tableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        if (weakself.totalElements/10.0 > (weakself.pageNo*1.0)) {
            weakself.pageNo ++;
            [weakself getListOfUserPostWithPageNo:weakself.pageNo];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.refreshFooterView endRefresh];
            });
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kRealHeightValue(8);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kRealHeightValue(8);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"Identifier_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ArticleTableViewCell" owner:self options:nil].firstObject;
    }
    cell.delegate = self;
    
    cell.model = self.modelArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticleTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
    PostDetailViewController *controller = [[PostDetailViewController alloc] init];
    UserPostModel *model = self.modelArray[indexPath.section];
    controller.topicId = model.id;
    controller.deletePost = ^{
        self.pageNo = 1;
        [self getListOfUserPostWithPageNo:self.pageNo];
    };
    controller.model = model;
    [self registerForPreviewingWithDelegate:self sourceView:cell];
    [self.navigationController pushViewController:controller animated:true];
}



#pragma mark - peek的代理方法，轻按即可触发弹出vc
- (UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    
    PostDetailViewController *controller = [[PostDetailViewController alloc] init];
    UserPostModel *model = self.modelArray[indexPath.section];
    controller.topicId = model.id;
    controller.deletePost = ^{
        self.pageNo = 1;
        [self getListOfUserPostWithPageNo:self.pageNo];
    };
    controller.model = model;
    return controller;
}

#pragma mark -  pop的代理方法，在此处可对将要进入的vc进行处理
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self.navigationController pushViewController:viewControllerToCommit animated:true];

}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath  {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2 animations:^{
        cell.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }];

    return YES;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2 animations:^{
        cell.transform = CGAffineTransformMakeScale(1, 1);
        return;
    }];
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
     return [UIImage imageNamed:@"empty"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:@"暂时还没有任何帖子..." attributes:@{NSForegroundColorAttributeName:kMainGrey,NSFontAttributeName:kFont(15)}];
    return att;
}

#pragma mark - ArticleTableViewCellDelegate
- (void)likePostWithModel:(UserPostModel *)model inCell:(nonnull ArticleTableViewCell *)cell {
    
    model.isLike = !model.isLike;
    
    [[DataBaseTools manager] likeFromTableName:HomeListTable model:model id:model.wd_fmdb_id successBlock:^{
        if (model.isLike) {
            [[BBSNetworkTool shareInstance] likePostWithTopicId:model.id successBlock:^(id  _Nonnull obj) {
                
            }];
        } else {
            [[BBSNetworkTool shareInstance] cancelLikePostWithTopicId:model.id successBlock:^(id  _Nonnull obj) {
                
            }];
        }
    } failBlock:^{
        
    }];
}

- (void)commentPostWithModel:(UserPostModel *)model {
    PostDetailViewController *controller = [[PostDetailViewController alloc] init];
    controller.topicId                   = model.id;
    controller.model = model;
    controller.deletePost = ^{
        self.pageNo = 1;
        [self getListOfUserPostWithPageNo:self.pageNo];
    };
    [self.navigationController pushViewController:controller animated:true];
}

#pragma mark - NetWork Request
- (void)getListOfUserPostWithPageNo:(NSInteger)pageNo {
    NSLog(@"--------------%ld", pageNo);
    [[BBSNetworkTool shareInstance] getPostListPageSize:@"10" pageNo:pageNo successBlock:^(id  _Nonnull obj) {
        if (pageNo == 1) {
            [[DataBaseTools manager] clearDataFromTableName:HomeListTable];
            for (NSDictionary *dic in obj[@"data"][@"list"]) {
                UserPostModel *model = [UserPostModel mj_objectWithKeyValues:dic];
                [[DataBaseTools manager] insertDataWithTableName:HomeListTable model:model successBlock:^{
                    
                } failBlock:^{
                    
                }];
            }
            [self readFromFMDB];

            [self.refreshHeaderView endRefresh];
        } else {
            for (NSDictionary *dic in obj[@"data"][@"list"]) {
                UserPostModel *model = [UserPostModel mj_objectWithKeyValues:dic];
                [[DataBaseTools manager] insertDataWithTableName:HomeListTable model:model successBlock:^{
                    
                } failBlock:^{
                    
                }];
            }
            [self readFromFMDB];

            [self.refreshFooterView endRefresh];
        }
        self.totalElements = [obj[@"data"][@"totalElements"] doubleValue];
        [self.tableView reloadData];
    } failBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.refreshHeaderView endRefresh];
        });
    }];
}

// 从数据中读取数据
- (void)readFromFMDB {
    self.modelArray = [NSMutableArray array];
    for (UserPostModel *model in [[DataBaseTools manager] queryAllDataWithTableName:HomeListTable]) {
        [self.modelArray addObject:model];
    }
}
@end
