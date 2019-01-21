//
//  UserInfoViewController.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/27.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoHeaderView.h"
#import "UserInfoTableViewCell.h"
#import "WDImagePicker.h"
#import "ModifyNickNameView.h"
#import "UserPostListViewController.h"
#import "ChangePasswordViewController.h"
#import "UserInfoModel.h"
#import "WudanHUD.h"
#import "LZAlterView.h"

@interface UserInfoViewController ()<LZAlterViewDelegate>

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) FCXRefreshHeaderView *refreshHeaderView;
@property (nonatomic, strong) UserInfoModel *userInfoModel;
@end

@implementation UserInfoViewController

#pragma mark  LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userInfoModel = (UserInfoModel *)[[DataBaseTools manager] queryAllDataWithTableName:UserInfoTable].firstObject;
}

#pragma mark  SetupSubviewsUI
- (void)setupSubviews{
    
    self.dataArray = @[@[@"昵称",@"修改登录密码",@"多设备登录"], @[@"清除缓存",@"退出登录"]];
    
    [self.tableView registerClass:[UserInfoTableViewCell class] forCellReuseIdentifier:@"UserInfoTableViewCell"];
    [self.view addSubview:self.tableView];
}

#pragma mark  SetupSubviewsConstraints
- (void)setupSubviewsConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(self.view).inset(20);
        }
    }];
}

#pragma mark  点击事件---用户帖子列表
- (void)postListVC {
    UserPostListViewController *controller = [[UserPostListViewController alloc] init];
    [self.navigationController pushViewController:controller animated:true];
}

#pragma mark  UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoTableViewCell" forIndexPath:indexPath];
    cell.titileLabel.text = self.dataArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.subTitileLabel.text = self.userInfoModel.nickname;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.subTitileLabel.text = [NSString stringWithFormat:@"%.2fM",[[UtilsManager shareInstance] getCacheSize]];
    } else if (indexPath.section == 0 && indexPath.row == 2 ) {
        UISwitch *swicth = [[UISwitch alloc] init];
        [swicth sizeToFit];
        [swicth setOn:self.userInfoModel.isSingleLogin];
        [swicth addTarget:self action:@selector(setLoginSingle:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = swicth;
    } else {
        cell.subTitileLabel.text = @"";
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kMainWhite;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : kRealHeightValue(10);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ModifyNickNameView *view = [[ModifyNickNameView alloc] init];
            kWeakSelf(view)
            view.changeNickNameHandler = ^(NSString *nickName) {
                [self changeNickName:nickName success:^{
                    [weakview dismissView];
                }];
            };
            [view showView];
        } else if (indexPath.row == 1){
            ChangePasswordViewController *controller = [[ChangePasswordViewController alloc] init];
            [self.navigationController pushViewController:controller animated:true];
        }
    } else {
     
        if (indexPath.row == 0) {
            [[UtilsManager shareInstance] cleanCache];
            
            [WudanHUD setStyle:WudanHUDStyleDark];
            
            [WudanHUD showIndicatorWithText:@"清理中..."];
        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [WudanHUD showImageViewWithImageName:[UIImage imageNamed:@"MBHUD_Info"] contentText:@"清理成功"];
                [WudanHUD dismissDelayTimeInterval:1.2];
                [self.tableView reloadData];
            });
        } else {
            
            [[[[LZAlterView alter] configureWithActionTitleArray:@[@"退出登录"] cancelActionTitle:@"取消"] setupDelegate:self] showAlter];
        }
    }
}

#pragma mark - LZAlterViewDelegate

- (void)alterView:(LZAlterView *)alterView didSelectedAtIndex:(NSInteger)index {
    [[BBSNetworkTool shareInstance] signOutrRequset];
}

#pragma mark - 设置是否单点登录
- (void)setLoginSingle:(id)sender {
    UISwitch *switchV = (UISwitch *)sender;
    
    NSString *isOn;
    
    if (switchV.isOn) {
        isOn = @"1";
        self.userInfoModel.isSingleLogin = YES;
    } else {
        isOn = @"0";
        self.userInfoModel.isSingleLogin = NO;
    }
  
    self.userInfoModel.isSingleLogin = switchV.isOn;
    
    [[DataBaseTools manager] updateDataWithTableName:UserInfoTable model:self.userInfoModel uid:self.userInfoModel.wd_fmdb_id successBlock:^{
        [[BBSNetworkTool shareInstance] modifyUserInfoWithHeaderImage:@"" nickName:@"" isSingleLogin:isOn successBlock:^(id  _Nonnull obj) {
        }];
    } failBlock:^{
        
    }];
}

- (void)changeNickName:(NSString *)nickName success:(void(^)(void))success {
    
    self.userInfoModel.nickname = nickName;
    
    [[DataBaseTools manager] updateDataWithTableName:UserInfoTable model:self.userInfoModel uid:self.userInfoModel.wd_fmdb_id successBlock:^{
        success();
        [[BBSNetworkTool shareInstance] modifyUserInfoWithHeaderImage:@"" nickName:nickName isSingleLogin:@"" successBlock:^(id  _Nonnull obj) {
        }];
        [self.tableView reloadData];
    } failBlock:^{
        
    }];
}

@end
