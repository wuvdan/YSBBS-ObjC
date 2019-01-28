//
//  MessageInfoViewController.m
//  YSBBSApp
//
//  Created by wudan on 2019/1/25.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import "MessageInfoViewController.h"
#import "MessageInfoTableViewCell.h"
#import "MessageInfo.h"
#import "MessageTimeView.h"

@interface MessageInfoViewController ()

@property (nonatomic, strong) MessageInfo *model;

@end

@implementation MessageInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    [self.wdNavigationBar.centerButton setTitle:@"消息详情" forState:UIControlStateNormal];
    [self.tableView registerClass:[MessageInfoTableViewCell class] forCellReuseIdentifier:@"MessageInfoTableViewCell"];
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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[BBSNetworkTool shareInstance] getMessageWithId:self.messagerId successBlock:^(id _Nonnull obj) {
       
        MessageInfo *model = [MessageInfo mj_objectWithKeyValues:obj[@"data"]];
        self.model = model;

        [self.tableView reloadData];
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MessageTimeView *view = [[MessageTimeView alloc] init];
    view.timeLabel.text = self.model.createTime;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30 * kScreenWidthRate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageInfoTableViewCell" forIndexPath:indexPath];
    cell.model = self.model;
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.tableView) {
        CGFloat sectionHeaderHeight = 30 * kScreenWidthRate;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

@end
