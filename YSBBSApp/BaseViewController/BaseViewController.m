//
//  BaseViewController.m
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/23.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "BaseViewController.h"
#import <objc/runtime.h>
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = true;
    
    [self setupNavigationBarStyle:UIBarStyleBlackOpaque];
    
    [self setupNavigationBar];
    [self setupSubviews];
    [self setupSubviewsConstraints];
    
}

#pragma mark - SetupNavigationBar
- (void)setupNavigationBar {
    [self wdNavigationBar];
}

#pragma mark - DidReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

- (void)dealloc {
    NSLogInfo(@"%@-释放了",self.class);
}

- (WDNavigationBar *)wdNavigationBar {
    if(!_wdNavigationBar) {
        _wdNavigationBar = ({
            WDNavigationBar *navView = [[WDNavigationBar alloc] init];
            [self.view addSubview:navView];
            navView.backgroundColor = kMainBlack;
            UIImage *backImage = kTempImageName(@"backItem");
            [navView.leftButton setImage:backImage forState:UIControlStateNormal];
            navView.tintColor = kMainWhite;
            navView.showBottomLabel = false;
            [navView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(0);
                make.height.mas_equalTo(44 + UIApplication.sharedApplication.statusBarFrame.size.height);
            }];
            [navView.centerButton setTitleColor:kMainWhite forState:UIControlStateNormal];
            [navView.superview layoutIfNeeded];
            navView;
        });
    }
    return _wdNavigationBar;
}
@end


#pragma mark  页面布局 
@implementation BaseViewController (viewLayout)

#pragma mark - SetupSubviewsUI
- (void)setupSubviews { }

#pragma mark - SetupSubviewsConstraints
- (void)setupSubviewsConstraints { }

@end


#pragma mark  tableView 

@implementation BaseViewController (tableView)

static char *TableViewKey = "tableViewKey";

- (UITableView *)tableView {
    
    UITableView *tableView = objc_getAssociatedObject(self, TableViewKey);
    if (!tableView) {
        tableView                    = [[UITableView alloc] init];
        tableView.backgroundColor    = UIColor.groupTableViewBackgroundColor;
        tableView.delegate           = self;
        tableView.dataSource         = self;
        tableView.rowHeight          = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 65.f;
        tableView.tableFooterView    = UIView.new;
        objc_setAssociatedObject(self, TableViewKey, tableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tableView;
}

- (void)setTableView:(UITableView *)tableView {
    /*
     objc_AssociationPolicy参数使用的策略：
     OBJC_ASSOCIATION_ASSIGN;            // assign策略
     OBJC_ASSOCIATION_COPY_NONATOMIC;    // copy策略
     OBJC_ASSOCIATION_RETAIN_NONATOMIC;  // retain策略
     
     OBJC_ASSOCIATION_RETAIN;
     OBJC_ASSOCIATION_COPY;
     */
    
    /*
     关联方法：
     objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
     
     参数：
     * id object 给哪个对象的属性赋值
     const void *key 属性对应的key
     id value  设置属性值为value
     objc_AssociationPolicy policy  使用的策略，是一个枚举值，和copy，retain，assign是一样的，手机开发一般都选择NONATOMIC
     */
    objc_setAssociatedObject(self, TableViewKey, tableView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * const reuserIdentify = @"baseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentify];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"默认文字-------%ld",(long)indexPath.section + 1];
    return cell;
}

@end

#pragma mark  导航栏配置 
@implementation BaseViewController (navgationBar)

- (void)setupNavigationBarStyle:(UIBarStyle)style {
    if (!style) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    } else {
        self.navigationController.navigationBar.barStyle = style;
    }
}

@end


#pragma mark  PUSH ViewController 
@implementation BaseViewController (isLogin)

- (void)pushControllerWithController:(UIViewController *)viewController {
    bool isLogin = [[DefaultsConfig objectForKey:G_IS_Login] boolValue];
    if (isLogin) {
        [self.navigationController pushViewController:viewController animated:true];
    } else {
        [DefaultsConfig cleanAllUserDefault];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    }
}

@end

