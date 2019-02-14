//
//  WDPageViewController.m
//  NestingView
//
//  Created by wudan on 2018/9/26.
//  Copyright © 2018 wudan. All rights reserved.
//

#import "WDPageViewController.h"
#import "WDPageCategory.h"
#import "WDPageSegmentView.h"
#import "UserInfoHeaderView.h"
#import "UserPostListViewController.h"
#import "UserInfoViewController.h"
#import "WDImagePicker.h"
#import "UserInfoModel.h"


#define kTopBarHeight           UIApplication.sharedApplication.statusBarFrame.size.height
#define StopHeight              kRealHeightValue(264) - UIApplication.sharedApplication.statusBarFrame.size.height - 44 - 45


@interface WDPageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView            *headerView;
@property (nonatomic, strong) UIScrollView      *backgroundScrollView;
@property (nonatomic, strong) UIViewController  *currentVC;
@property (nonatomic, assign) CGFloat           headerHeight;
@property (nonatomic, strong) UIScrollView      *headerScrollView;
@property (nonatomic, strong) WDPageSegmentView *segmentView;
@property (nonatomic, strong) NSArray           *vcArray;
@property (nonatomic, strong) UserInfoHeaderView *headerImageView;

@end

@implementation WDPageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    [self.wdNavigationBar.centerButton setTitle:@"个人中心" forState:UIControlStateNormal];
    self.wdNavigationBar.showBottomLabel = false;
}

- (void)setupSubviews {
     [self configBottomScrollView];
    self.headerHeight = kRealHeightValue(264);
    
    
    
    NSArray *vcArray = @[[[UserPostListViewController alloc] init],
                         [[UserInfoViewController alloc] init]];
    
    self.backgroundScrollView.contentSize = CGSizeMake(kSCREEN_WIDTH *vcArray.count, 0);
        
    for (int i=0; i<vcArray.count; i++) {
        UIViewController *vc = vcArray[i];
        vc.view.frame = CGRectMake(kSCREEN_WIDTH * i, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [self addChildViewController:vc];
        [self.backgroundScrollView addSubview:vc.view];
        
        for (UIView *view in vc.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]] || [view isKindOfClass:[UICollectionView class]] ||  [view isKindOfClass:[UITableView class]]) {
                UIScrollView *scrollView = (UIScrollView *)view;
                vc.rootScrollView = scrollView;
                if ([view isKindOfClass:[UITableView class]]) {
                    UITableView *tableView = (UITableView *)view;
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, self.headerHeight - kTopBarHeight)];
                    tableView.tableHeaderView = view;
                } else if ([view isKindOfClass:[UIScrollView class]]) {
                    
                }
                [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            }
        }
    }
    
    self.headerView = [self getHeaderViewWithImageName:@"" titleArray:@[@"我的帖子", @"设置"] height:self.headerHeight];
    [self.view addSubview:self.headerView];
    
    [self.view addSubview:self.headerView];
    [self.view bringSubviewToFront:self.headerImageView];
    [self.view bringSubviewToFront:self.wdNavigationBar];
}

#pragma mark  观察者模式 
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        CGFloat offset = [change[NSKeyValueChangeNewKey] CGPointValue].y;
        UITableView *tableView = object;
        
        if (offset <= (StopHeight) && offset >= 0) {
            self.headerView.y = -offset;
            self.headerView.height = self.headerHeight;
            for (UIViewController *vc in self.childViewControllers) {
                if (vc.rootScrollView.contentOffset.y != tableView.contentOffset.y) {
                    vc.rootScrollView.contentOffset = tableView.contentOffset;
                }
            }
        } else if(offset > StopHeight) { // 悬停
            self.headerView.y = - (StopHeight);
            self.headerView.height =  self.headerHeight;
            
            for (UIViewController *vc in self.childViewControllers) {
                if (vc.rootScrollView.contentOffset.y < StopHeight) {
                    vc.rootScrollView.contentOffset = CGPointMake(vc.rootScrollView.contentOffset.x, StopHeight);
                }
            }
        } else if (offset < 0) {
            self.headerView.y = 0;
            self.headerView.height = self.headerHeight - offset;
            for (UIViewController *vc in self.childViewControllers) {
                if (vc.rootScrollView.contentOffset.y != tableView.contentOffset.y) {
                    vc.rootScrollView.contentOffset = tableView.contentOffset;
                }
            }
        }
    }
}

#pragma mark  UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width);
    self.currentVC = self.vcArray[index];
    [self.segmentView scrollToIndex:index];
}

#pragma mark  绘制headerView 
- (UIView *)getHeaderViewWithImageName:(NSString *)imageName titleArray:(NSArray<NSString *> *)aTitleArray height:(CGFloat)aHeight{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, aHeight)];
    view.backgroundColor = kMainBlack;
    
    FLAnimatedImageView *imageView   = [[FLAnimatedImageView alloc] init];
    imageView.clipsToBounds          = false;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = true;
    [view addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updataHeaderImage:)];
    [imageView addGestureRecognizer:tap];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(view);
        make.width.height.mas_equalTo(100);
    }];
    
    imageView.layer.cornerRadius  = 100/2;
    imageView.layer.masksToBounds = true;
    imageView.layer.borderWidth   = 1;
    imageView.layer.borderColor   = kMainWhite.CGColor;
    
    UserInfoModel *model = (UserInfoModel *)[[DataBaseTools manager] queryAllDataWithTableName:UserInfoTable].firstObject;
    NSString *url = [NSString stringWithFormat:@"%@/%@", G_Http_URL, model.headPic];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]
                                  placeholderImage:kImageName(@"Default")];

    WDPageSegmentView *segmentView = [[WDPageSegmentView alloc] init];
    segmentView.titleArray = aTitleArray;
    [view addSubview:segmentView];
    [segmentView setScrollToIndexBlock:^(NSInteger index) {
        [self.backgroundScrollView setContentOffset:CGPointMake(kSCREEN_WIDTH * index, 0) animated:true];
        self.currentVC = self.vcArray[index];
    }];
    
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(view);
        make.height.mas_equalTo(45);
    }];
    
    self.segmentView = segmentView;

    return view;
}

- (void)updataHeaderImage:(UITapGestureRecognizer *)sender {
    [[WDImagePicker shared] startWithVC:self];
    [[WDImagePicker shared] setPickerCompletion:^(WDImagePicker *picker, NSError *error, UIImage *image) {
        if (image) {
            UserInfoModel *model = (UserInfoModel *)[[DataBaseTools manager] queryAllDataWithTableName:UserInfoTable].firstObject;
            
            [[BBSNetworkTool shareInstance] uploadHeaderImageView:image successBlock:^(id  _Nonnull obj) {
                model.headPic = obj[@"data"][0];
                [[DataBaseTools manager] updateDataWithTableName:UserInfoTable model:model uid:model.wd_fmdb_id successBlock:^{
                    UIImageView *imageView = (UIImageView *)sender.view;
                    imageView.image = image;
                    [[BBSNetworkTool shareInstance] modifyUserInfoWithHeaderImage:obj[@"data"][0] nickName:@"" isSingleLogin:@"" successBlock:^(id  _Nonnull obj) {
                    }];
                } failBlock:^{
                    
                }];
            }];
        } else {
            NSLogWarn(@"取消修改");
        }
    }];
}

#pragma mark  配置底部ScrollView 
- (void)configBottomScrollView {
    self.backgroundScrollView                                = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    self.backgroundScrollView.delegate                       = self;
    self.backgroundScrollView.pagingEnabled                  = YES;
    self.backgroundScrollView.bounces                        = NO;
    self.backgroundScrollView.backgroundColor                = UIColor.whiteColor;
    self.backgroundScrollView.showsVerticalScrollIndicator   = NO;
    self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.backgroundScrollView];
    
    if (@available(iOS 11.0, *)) {
        self.backgroundScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
@end
