//
//  PostArticleImageCollectionViewTableViewCell.h
//  YSBBSApp
//
//  Created by wudan on 2019/1/17.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XG_AssetModel;

@interface PostArticleImageCollectionViewTableViewCell : UITableViewCell
@property (nonatomic, copy) void (^collectionViewTableViewCellRefresh)(NSArray<XG_AssetModel *> *imageModelArray);
@end

NS_ASSUME_NONNULL_END
