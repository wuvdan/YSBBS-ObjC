//
//  SelectCategoryView.m
//  BBSApp
//
//  Created by 吴丹 on 2018/8/14.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "SelectCategoryView.h"

@interface SelectCategoryView  ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger selectedSection;

@end

@implementation SelectCategoryView

- (instancetype)init{

    self = [super init];
    if(self){
        self.selectedSection = 999;
        [self loadData];
        
        [self setupSubviews];
        [self setupSubviewsConstraints];
    }
    return self;
}

- (void)loadData {
    self.dataArray = @[@"iOS",@"安卓",@"Web前端",@"Java后台"];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] init];
            tableView.backgroundColor = UIColor.groupTableViewBackgroundColor;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.rowHeight = kRealHeightValue(65.f);
            tableView.tableFooterView = UIView.new;
            tableView;
        });
    }
    return _tableView;
}

#pragma mark -- UITableViewDelagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * const reuserIdentify = @"Category";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentify];
    }
    cell.textLabel.text = self.dataArray[indexPath.section];
    
    UIImage *image = [[UIImage imageNamed:@"对号"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *accImageView = [[UIImageView alloc] init];
    accImageView.contentMode = UIViewContentModeScaleAspectFit;
//    accImageView.size = CGSizeMake(30, 30);
//    accImageView.tintColor = KBaseColor;
    cell.accessoryView = accImageView;
    
    if (self.selectedSection == indexPath.section) {
        accImageView.image = image;
    } else {
        accImageView.image = [UIImage new];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedSection = indexPath.section;
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissView];
    });
}

#pragma mark - SetupSubviewsUI
- (void)setupSubviews{
    [self addSubview:self.tableView];
}

#pragma mark - SetupSubviewsConstraints
- (void)setupSubviewsConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.leading.trailing.mas_equalTo(self).inset(kRealWidthValue(65));
        make.height.mas_equalTo(kRealHeightValue(65)*self.dataArray.count);
    }];
}



@end
