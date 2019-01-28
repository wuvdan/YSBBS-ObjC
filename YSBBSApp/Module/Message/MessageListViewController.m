//
//  MessageListViewController.m
//  YSBBSApp
//
//  Created by wudan on 2019/1/25.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import "MessageListViewController.h"
#import "WDPageSegmentView.h"
#import "MessageTableViewCell.h"
#import "MessageMode.h"
#import "MessageInfoViewController.h"

@interface MessageListViewController ()

@property (nonatomic, strong) NSMutableArray<MessageMode *> *modelArray;
@property (nonatomic, strong) FCXRefreshHeaderView *refreshHeaderView;
@property (nonatomic, strong) FCXRefreshFooterView *refreshFooterView;
@property (nonatomic, assign) NSInteger            pageNo;
@property (nonatomic, assign) NSInteger            totalPages;

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    
    self.pageNo        = 1;
    self.totalPages    = 0;
    
    [self.wdNavigationBar.centerButton setTitle:@"消息" forState:UIControlStateNormal];
    [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"MessageTableViewCell"];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(self.wdNavigationBar.mas_bottom);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view);
        }
    }];
    
    [self getDataListWithPageNo:self.pageNo];
    
    [self refreshData];
}

#pragma mark - 数据刷新
- (void)refreshData {
    kWeakSelf(self)
    self.refreshHeaderView = [self.tableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        weakself.pageNo = 1;
        [weakself getDataListWithPageNo:weakself.pageNo];
    }];
    
    self.refreshFooterView = [self.tableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        if (weakself.totalPages > weakself.pageNo) {
            weakself.pageNo ++;
            [weakself getDataListWithPageNo:weakself.pageNo];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.refreshFooterView endRefresh];
            });
        }
    }];
}


- (void)getDataListWithPageNo:(NSInteger)pageNo {
    
    [[BBSNetworkTool shareInstance] getMessageWithPageNo:pageNo successBlock:^(id  _Nonnull obj) {
        NSLog(@"%@", obj);
        
        if (pageNo == 1) {
            self.modelArray = [NSMutableArray array];
            
            for (NSDictionary *dic in obj[@"data"][@"list"]) {
                MessageMode *model = [MessageMode mj_objectWithKeyValues:dic];
                [self.modelArray addObject:model];
            }
            [self.refreshHeaderView endRefresh];

        } else {
            for (NSDictionary *dic in obj[@"data"][@"list"]) {
                MessageMode *model = [MessageMode mj_objectWithKeyValues:dic];                
                [self.modelArray insertObject:model atIndex:0];
            }
            
            [self.refreshFooterView endRefresh];
        }
        
        self.totalPages = [obj[@"data"][@"totalPages"] integerValue];
        [self.tableView reloadData];
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30 * kScreenWidthRate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell" forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    MessageInfoViewController *vc = [[MessageInfoViewController alloc] init];
    vc.messagerId = self.modelArray[indexPath.section].messageId;
    [self.navigationController pushViewController:vc animated:true];
}

@end
