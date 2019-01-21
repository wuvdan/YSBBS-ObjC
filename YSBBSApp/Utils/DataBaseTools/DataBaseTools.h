//
//  HomeListDataBase.h
//  YSBBSApp
//
//  Created by wudan on 2018/11/16.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (addId)

@property (nonatomic) NSInteger wd_fmdb_id;

@end

typedef void(^successBlock)(void);
typedef void(^failBlock)(void);

@interface DataBaseTools : NSObject

+ (instancetype)manager;
/** 创建表 */
- (void)createTableWithName:(NSString *)name;
/** 删除表 */
- (void)dropTable:(NSString *)tableName;
/** 添加数据 */
- (void)insertDataWithTableName:(NSString *)tableName model:(NSObject *)model successBlock:(successBlock)aSuccessBlock failBlock:(failBlock)aFailBlock;
/** 更新数据 */
- (void)updateDataWithTableName:(NSString *)tableName model:(NSObject *)model uid:(NSInteger)aUid successBlock:(successBlock)aSuccessBlock failBlock:(failBlock)aFailBlock;
/** 删除数据 */
- (void)deleteDataWithTableName:(NSString *)tableName uid:(NSInteger)uid successBlock:(successBlock)aSuccessBlock failBlock:(failBlock)aFailBlock;
/** 查询全部数据 */
- (NSArray<NSObject *> *)queryAllDataWithTableName:(NSString *)tableName;
/** 清除数据 */
- (void)clearDataFromTableName:(NSString *)tableName;
/** 点赞 */
- (void)likeFromTableName:(NSString *)tableName model:(NSObject *)model id:(NSInteger)aId successBlock:(successBlock)aSuccessBlock failBlock:(failBlock)aFailBlock;
@end

NS_ASSUME_NONNULL_END
