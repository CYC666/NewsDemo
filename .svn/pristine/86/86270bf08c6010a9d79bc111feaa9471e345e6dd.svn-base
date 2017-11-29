//
//  CoreDataTool.m
//  LFBaseFrameTwo
//
//  Created by admin on 16/12/15.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "CoreDataTool.h"
#import "AppDelegate.h"

@implementation CoreDataTool

static CoreDataTool *instance;
+ (CoreDataTool *)sharedInstance{
    @synchronized(self) {
        if (!instance) {
            instance = [[CoreDataTool alloc]init];
        }
    }
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self) {
        if (!instance) {
            instance = [super allocWithZone:zone];
        }
    }
    return instance;
}

- (id)init{
    if (self = [super init]) {
        //初始化
        _searchKeyLists = [NSMutableArray array];
        
    }
    return self;
}


/*!
 * SearchKeyLocal类的数据库操作，增删改查
 */

//读取SearchKeyLocal表中的数据
- (void)readSearchKeyLocalData{
    //清空原始数据
    [_searchKeyLists removeAllObjects];
    
    //使用coredata方式读取数据
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //获取所有实体对象
    NSDictionary *dic = [appDelegate.managedObjectModel entitiesByName];
    NSEntityDescription *entity = [dic valueForKey:@"SearchKeyLocal"];
    
    //创建读取实体的读取对象
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (NSManagedObject *everyObject in result) {
        NSString *time = [everyObject valueForKey:@"time"];
        NSString *searchStr = [everyObject valueForKey:@"searchStr"];
        
        SearchKeyLocal *searchKeyLocal = [[SearchKeyLocal alloc] initWithTime:time searchStr:searchStr];
        
        [_searchKeyLists addObject:searchKeyLocal];
    }
}
//写入SearchKeyLocal表中的数据
- (void)writeSearchKeyLocalData:(SearchKeyLocal *)newSearchKeyLocal{
    //将数据存入单例中的对象
    [_searchKeyLists addObject:newSearchKeyLocal];
    
    //然后再给coredata中添加这条数据
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObject *searchKeyLocalData = [NSEntityDescription insertNewObjectForEntityForName:@"SearchKeyLocal" inManagedObjectContext:appDelegate.managedObjectContext];
    [searchKeyLocalData setValue:newSearchKeyLocal.time forKey:@"time"];
    [searchKeyLocalData setValue:newSearchKeyLocal.searchStr forKey:@"searchStr"];
    
    //保存到数据库
    [appDelegate saveContext];
}
//删除SearchKeyLocal表中的数据，根据“searchStr”字段
- (void)deleteSearchKeyLocalData:(NSString *)deleteKey{
    //将删除单例中的对象
    SearchKeyLocal *searchKeyLocal;
    for (NSInteger i = 0; i<_searchKeyLists.count; i++) {
        searchKeyLocal = _searchKeyLists[i];
        if (searchKeyLocal.searchStr == deleteKey) {
            //删除
            [_searchKeyLists removeObject:searchKeyLocal];
            //跳出循环
            break;
        }
        //如果循环结束了也没有找到，则直接return
        if (i == _searchKeyLists.count - 1) {
            return;
        }
    }
    
    //删除coredata数据库中的数据,useRecord
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //获取所有实体对象
    NSDictionary *dic = [appDelegate.managedObjectModel entitiesByName];
    NSEntityDescription *entity = [dic valueForKey:@"SearchKeyLocal"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"searchStr = %@",searchKeyLocal.searchStr];
    
    //创建读取实体的读取对象
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    fetchRequest.predicate = predicate;
    
    //查询符合条件的数据
    NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (NSManagedObject *everyObj in result) {
        //逐条删除
        [appDelegate.managedObjectContext deleteObject:everyObj];
    }
    [appDelegate saveContext];
}
//清空SearchKeyLocal表中的数据
- (void)clearSearchKeyLocalData{
    //清空单例中的对象
    [_searchKeyLists removeAllObjects];
    
    //清空coredata数据库中的数据
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //获取所有实体对象
    NSDictionary *dic = [appDelegate.managedObjectModel entitiesByName];
    NSEntityDescription *entity = [dic valueForKey:@"SearchKeyLocal"];
    
    //创建读取实体的读取对象
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    
    //查询所有数据
    NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (NSManagedObject *everyObj in result) {
        //逐条删除
        [appDelegate.managedObjectContext deleteObject:everyObj];
    }
    [appDelegate saveContext];
    
}




@end
