//
//  ArticleTableViewCell.m
//  YSBBSApp
//
//  Created by wudan on 2018/11/14.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "ArticleTableViewCell.h"
#import "ArticleImageCollectionViewCell.h"
#import "UserPostModel.h"

#import "ELBrowser.h"
#import "ELPhotoListModel.h"
#import "ELPhotoBrowserView.h"

@interface ArticleTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *imgArray;

@end

@implementation ArticleTableViewCell

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ArticleImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ArticleImageCollectionViewCell" forIndexPath:indexPath];
    cell.imgUrlString = self.imgArray[indexPath.item];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *urls = self.imgArray;
    
    NSMutableArray * thumbnailImageUrls = [NSMutableArray array];
    NSMutableArray * originalImageUrls = [NSMutableArray array];
    for (NSDictionary * dic in urls) {
        [thumbnailImageUrls addObject:[NSString stringWithFormat:@"%@/%@",G_Http_URL,dic]];
        [originalImageUrls addObject:[NSString stringWithFormat:@"%@/%@",G_Http_URL,dic]];
    }
    
    ELBrowserConfig * config = [[ELBrowserConfig alloc]init];
    config.originalUrls = originalImageUrls;//大图
    config.smallUrls = thumbnailImageUrls;//缩略图 (必传)
    config.width = 10;//宽度 (必传)
    config.progressPathWidth = 1;
    
    //将所有的数据封装到数据模型中 再传到要展示的大图视图中
    ELPhotoListModel * model = [[ELPhotoListModel alloc]init];
    model.listCollectionView = self.collectionView;
    model.indexPath = indexPath;
    model.originalUrls = originalImageUrls.count ==originalImageUrls.count ? originalImageUrls : thumbnailImageUrls;
    model.smallUrls = thumbnailImageUrls;
    
    NSMutableArray * imgArr = [NSMutableArray array];
    for (int a= 0; a < thumbnailImageUrls.count; a++) {
        ArticleImageCollectionViewCell * cell = (ArticleImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:a inSection:0]];
        UIImage * image = cell.imageView.image;
        if (image) {
            [imgArr addObject:image];
        } else {
            [imgArr addObject:[UIImage imageNamed:@"ELBroswerImg.bundle/placeholderimage"]];
        }
    }
    model.imgArr = imgArr;
    
    NSMutableArray * mutArr = [NSMutableArray array];
    for (int a = 0; a < model.smallUrls.count; a++) {
        ELPhotoModel * photoModel = [[ELPhotoModel alloc]init];
        photoModel.smallURL       = model.smallUrls[a];
        photoModel.picURL         = model.originalUrls[a];
        photoModel.image          = model.imgArr[a];
        photoModel.listCellF      = [self listCellFrame:[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:a inSection:indexPath.section]]];
        photoModel.needAnimation  = a == indexPath.row ? YES : NO;
        photoModel.config         = config;
        [mutArr addObject:photoModel];
    }
    model.photoModels = mutArr;
    
    ELPhotoBrowserView * photoView = [[ELPhotoBrowserView alloc]init];
    photoView.listModel = model;
    [photoView show];
}

/**
 获取listCell 在window中的对应位置
 
 @param cell cell
 @return 对应的frame
 */
- (CGRect)listCellFrame:(UICollectionViewCell *)cell {
    CGRect cellRect = [self.collectionView convertRect:cell.frame toView:self.collectionView];
    CGRect cell_window_rect = [self.collectionView convertRect:cellRect toView:UIApplication.sharedApplication.delegate.window];
    return cell_window_rect;
}

- (void)setModel:(UserPostModel *)model {
    _model = model;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",G_Http_URL,model.headPic]] placeholderImage:kImageName(@"Default")];
    
    self.nickNameLabel.text = model.nickname;
    self.titleLabel.text    = model.title;
    self.contentLabel.text  = model.content;
    self.timeLabel.text = [[UtilsManager shareInstance] setupCreateTime:model.createTime];
    
    [self.likeButton setTitle:[NSString stringWithFormat:@"%ld",(long)model.likeNum] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%ld",(long)model.commentNum] forState:UIControlStateNormal];
    
    if (model.isLike) {
        self.likeButton.tintColor = kMainDarkGreen;
    } else {
        self.likeButton.tintColor = UIColor.lightGrayColor;
    }
    
    if (model.img.length > 0) {
        
        self.imgArray = [self.model.img componentsSeparatedByString:@","];
        
        CGFloat width                       = (kSCREEN_WIDTH - kRealWidthValue(30 + 60))/3;
        self.layout.itemSize                = CGSizeMake(width, width);
        self.layout.scrollDirection         = UICollectionViewScrollDirectionVertical;
        self.layout.minimumInteritemSpacing = 0;
        self.layout.minimumLineSpacing      = 0;
        self.layout.sectionInset = UIEdgeInsetsZero;
        
        if (self.imgArray.count == 0) {
            [[self.collectionView.heightAnchor constraintEqualToConstant:0] setActive:true];
        } else if (self.imgArray.count <= 3) {
            [[self.collectionView.heightAnchor constraintEqualToConstant:width] setActive:true];
        } else if (self.imgArray.count <= 6) {
            [[self.collectionView.heightAnchor constraintEqualToConstant:width * 2 + kRealHeightValue(10)] setActive:true];
        } else {
            [[self.collectionView.heightAnchor constraintEqualToConstant:width * 3 + kRealHeightValue(20)] setActive:true];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius                  = 10;
    self.layer.masksToBounds                 = YES;
    self.headerImageView.layer.cornerRadius  = self.headerImageView.frame.size.width/2;
    self.headerImageView.layer.masksToBounds = YES;
   
    self.collectionView.delegate             = self;
    self.collectionView.dataSource           = self;
    self.likeButton.tintColor                = UIColor.lightGrayColor;
    self.headerImageView.userInteractionEnabled = true;
    self.nickNameLabel.userInteractionEnabled = true;
    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTouched:)];
    UITapGestureRecognizer *tapGusture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTouched:)];
    
    [self.headerImageView addGestureRecognizer:tapGusture1];
    [self.nickNameLabel addGestureRecognizer:tapGusture];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ArticleImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ArticleImageCollectionViewCell"];
}

- (void)userInfoTouched:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userInfoWithModel:)]) {
        [self.delegate userInfoWithModel:self.model];
    }
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x = kRealWidthValue(15);
    frame.size.width -= frame.origin.x + kRealWidthValue(15);
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)likeTouched:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if ([sender.tintColor isEqual:kMainDarkGreen]) {
        self.likeButton.tintColor = kMainGrey;
        self.model.likeNum --;
        [self.likeButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.model.likeNum] forState:UIControlStateNormal];
    } else {
        self.likeButton.tintColor = kMainDarkGreen;
        self.model.likeNum ++;
        [self.likeButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.model.likeNum] forState:UIControlStateNormal];
    }
        
    if ([self.delegate respondsToSelector:@selector(likePostWithModel:inCell:)]) {
        [self.delegate likePostWithModel:self.model inCell:self];
    }
}

- (IBAction)commnetTouched:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(commentPostWithModel:)]) {
        [self.delegate commentPostWithModel:self.model];
    }
}

@end
