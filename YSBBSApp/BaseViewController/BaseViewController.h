//
//  BaseViewController.h
//  YSBBSApp
//
//  Created by 吴丹 on 2018/8/23.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WDNavigationBar.h>

@interface BaseViewController : UIViewController
/**
 This view replaces the navigation bar of the system and defines attributes such as colors. It is not added to the view by default.
 If you need to use it, add it to the view.
 */
@property (nonatomic, strong) WDNavigationBar * _Nullable wdNavigationBar;

/**
 *    Set navigation bar properties and styles
 */
- (void)setupNavigationBar;

@end

#pragma mark  页面布局 
@interface  BaseViewController (viewLayout)

/**
 *    Setting initialization page controls
 */
- (void)setupSubviews;

/**
 *    Setting up page control layout
 */
- (void)setupSubviewsConstraints;

@end

#pragma mark  TableView 
@interface BaseViewController (tableView) <UITableViewDelegate, UITableViewDataSource>

/**
 *  TableView
 *  The tableView is not in the view by default, unless it is added to the view when necessary.
 */
@property (nonatomic, strong)  UITableView * _Nullable tableView;

@end


#pragma mark  导航栏配置 
@interface BaseViewController (navgationBar)
/**
 Set the status bar style. The default style is white.

 @param style UIBarStyle
 */
- (void)setupNavigationBarStyle:(UIBarStyle)style;

@end

#pragma mark  PUSH ViewController 
@interface BaseViewController (isLogin)

/**
 * A controller that jumps to the login page if logged in, depending on whether the user is logged in or not

 @param viewController Push controller if needed
 */
- (void)pushControllerWithController:(UIViewController *)viewController;

@end
