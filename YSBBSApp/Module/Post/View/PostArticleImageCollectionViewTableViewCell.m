//
//  PostArticleImageCollectionViewTableViewCell.m
//  YSBBSApp
//
//  Created by wudan on 2019/1/17.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import "PostArticleImageCollectionViewTableViewCell.h"
#import "PostArticleImageCollectionViewCell.h"

#import "XG_AssetPickerController.h"

@interface PostArticleImageCollectionViewTableViewCell () <XG_AssetPickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<XG_AssetModel *> *assets;
@property (nonatomic, strong) XG_AssetModel *placeholderModel;

@end

@implementation PostArticleImageCollectionViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViewProperties];
        [self setupViewConstraint];
    }
    return self;
}

- (void)setupViewProperties {
    [self.contentView addSubview:self.collectionView];
}

- (void)setupViewConstraint {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.leading.trailing.mas_equalTo(self.contentView).inset(15);
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PostArticleImageCollectionViewCell *cell = (PostArticleImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PostArticleImageCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.assets[indexPath.item];
    [cell.deleteBtn addTarget:self action:@selector(onDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XG_AssetModel *model = self.assets[indexPath.item];
    if (model.isPlaceholder) {
        [self openAlbum];
    }
}

#pragma mark - XG_AssetPickerControllerDelegate

- (void)assetPickerController:(XG_AssetPickerController *)picker didFinishPickingAssets:(NSArray<XG_AssetModel *> *)assets{
    NSMutableArray *newAssets = assets.mutableCopy;
    if (newAssets.count < 9 ) {
        [newAssets addObject:self.placeholderModel];
    }
    
    if (self.collectionViewTableViewCellRefresh) {
        self.collectionViewTableViewCellRefresh(assets);
    }
    
    self.assets = newAssets;
    [self.collectionView reloadData];
}


- (void)openAlbum{
    __weak typeof (self) weakSelf = self;
    [[XG_AssetPickerManager manager] handleAuthorizationWithCompletion:^(XG_AuthorizationStatus aStatus) {
        if (aStatus == XG_AuthorizationStatusAuthorized) {
            [weakSelf showAssetPickerController];
        }else{
            [weakSelf showAlert];
        }
    }];
}

- (void)showAssetPickerController{
    XG_AssetPickerOptions *options = [[XG_AssetPickerOptions alloc]init];
    options.maxAssetsCount = 9;
    options.videoPickable = false;
    NSMutableArray<XG_AssetModel *> *array = [self.assets mutableCopy];
    [array removeLastObject];//去除占位model
    options.pickedAssetModels = array;
    XG_AssetPickerController *photoPickerVc = [[XG_AssetPickerController alloc] initWithOptions:options delegate:self];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:photoPickerVc];
    [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void)showAlert{
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未开启相册权限，是否去设置中开启？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancan = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    
    [alter addAction:cancan];
    [alter addAction:sure];
    
    [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:alter animated:true completion:nil];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        CGFloat w =  kPOST_ARTICL_IMGAGE_WIDTH;
        flowLayout.itemSize = CGSizeMake(w, w);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"PostArticleImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PostArticleImageCollectionViewCell"];
    }
    return _collectionView;
}

-(NSMutableArray<XG_AssetModel *> *)assets{
    if (!_assets) {
        _assets = @[self.placeholderModel].mutableCopy;
    }
    return _assets;
}

- (XG_AssetModel *)placeholderModel{
    if (!_placeholderModel) {
        _placeholderModel = [[XG_AssetModel alloc]init];
        _placeholderModel.isPlaceholder = YES;
    }
    return _placeholderModel;
}

- (void)onDeleteBtnClick:(UIButton *)sender{
    PostArticleImageCollectionViewCell *cell = (PostArticleImageCollectionViewCell *)sender.superview.superview;
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[indexpath]];
        [self.assets removeObjectAtIndex:indexpath.item];
        if (self.assets.count == 8 && ![self.assets containsObject:self.placeholderModel]) {
            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:8 inSection:0]]];
            [self.assets addObject:self.placeholderModel];
        }
        
        if ([self.assets containsObject:self.placeholderModel]) {
            NSMutableArray *array = self.assets.mutableCopy;
            [array removeObject:self.placeholderModel];
            if (self.collectionViewTableViewCellRefresh) {
                self.collectionViewTableViewCellRefresh(array);
            }
        } else {
            NSMutableArray *array = self.assets.mutableCopy;
            if (self.collectionViewTableViewCellRefresh) {
                self.collectionViewTableViewCellRefresh(array);
            }
        }
    } completion:^(BOOL finished) {
        
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
