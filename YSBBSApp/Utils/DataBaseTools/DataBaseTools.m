//
//  HomeListDataBase.m
//  YSBBSApp
//
//  Created by wudan on 2018/11/16.
//  Copyright © 2018 forever.love. All rights reserved.
//

#import "DataBaseTools.h"
#import <FMDB.h>
#import <objc/runtime.h>

static char *wd_id_key = "key";
@implementation NSObject (addId)

- (NSInteger)wd_fmdb_id {
    NSNumber *numberValue = objc_getAssociatedObject(self, wd_id_key);
    return numberValue.integerValue;
}

- (void)setWd_fmdb_id:(NSInteger)wd_fmdb_id {
    objc_setAssociatedObject(self, wd_id_key, @(wd_fmdb_id), OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface DataBaseTools ()

@property (nonatomic, strong) FMDatabase *fmdb;

@end

@implementation DataBaseTools

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static DataBaseTools *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[DataBaseTools alloc] init];
    });
    return manager;
}

- (void)createTableWithName:(NSString *)name {
    [self.fmdb open];
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement,model BLOB)", name];
    BOOL result = [self.fmdb executeUpdate:sql];
    if (result) {
        NSLog(@"表创建成功");
    }
}

- (void)dropTable:(NSString *)tableName {
    NSString *sql = [NSString stringWithFormat:@"drop table if exists %@", tableName];
    BOOL result = [self.fmdb executeUpdate:sql];
    if (result) {
        NSLog(@"表删除成功");
    }
}

- (void)insertDataWithTableName:(NSString *)tableName model:(NSObject *)model successBlock:(successBlock)aSuccessBlock failBlock:(failBlock)aFailBlock {
    NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:model];
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (model) values(?)", tableName];
    BOOL result = [self.fmdb executeUpdate:sql withArgumentsInArray:@[modelData]];
    if (result) {
        aSuccessBlock();
    } else {
        aFailBlock();
    }
}

- (void)updateDataWithTableName:(NSString *)tableName model:(NSObject *)model uid:(NSInteger)aUid successBlock:(successBlock)aSuccessBlock failBlock:(failBlock)aFailBlock {
    NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:model];
    NSString *sql = [NSString stringWithFormat:@"update %@ set model = ? where id = ?", tableName];
    BOOL result = [self.fmdb executeUpdate:sql withArgumentsInArray:@[modelData, @(aUid)]];
    if (result) {
        aSuccessBlock();
    } else {
        aFailBlock();
    }
}

- (void)deleteDataWithTableName:(NSString *)tableName uid:(NSInteger)uid successBlock:(successBlock)aSuccessBlock failBlock:(failBlock)aFailBlock {
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where id = ?", tableName];
    BOOL result = [self.fmdb executeUpdate:sql withArgumentsInArray:@[@(uid)]];
    if (result) {
        aSuccessBlock();
    } else {
        aFailBlock();
    }
}

- (NSArray<NSObject *> *)queryAllDataWithTableName:(NSString *)tableName {
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from %@",tableName];
    @try {
        FMResultSet *rs = [self.fmdb executeQuery:sql];
        while (rs.next) {
            NSObject *model = [[NSObject alloc] init];
            NSData *modelData = [rs dataForColumn:@"model"];
            int uid = [rs intForColumn:@"id"];
            
            model = [NSKeyedUnarchiver unarchiveObjectWithData:modelData];
            model.wd_fmdb_id = uid;
            [array addObject:model];
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", self.fmdb.lastError);
    } @finally {
        NSLog(@"查询数据");
    }
    
    return array;
}

- (FMDatabase *)fmdb {
    if (!_fmdb) {
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/Article.db"];
        _fmdb = [[FMDatabase alloc] initWithPath:path];
    }
    return _fmdb;
}

- (void)clearDataFromTableName:(NSString *)tableName {

 
    [self dropTable:tableName];
    [self createTableWithName:tableName];
    
}

- (void)likeFromTableName:(NSString *)tableName model:(NSObject *)model id:(NSInteger)aId successBlock:(successBlock)aSuccessBlock failBlock:(failBlock)aFailBlock {
    [self updateDataWithTableName:tableName model:model uid:model.wd_fmdb_id successBlock:^{
        aSuccessBlock();
    } failBlock:^{
        aFailBlock();
    }];
}

@end
