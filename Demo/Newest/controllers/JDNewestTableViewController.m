//
//  NewestTableViewController.m
//  Demo
//
//  Created by he15his on 15/10/19.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import "JDNewestTableViewController.h"
#import "JDNewestTableViewCell.h"
#import "JDNewestObject.h"
#import "JDDateFormatter.h"
#import <MJRefresh.h>
#import <SVProgressHUD.h>
#import "JDAddCasusTableViewController.h"
#import <TMCache.h>
#import "JDTMCacheKeyConstan.h"

#define kPageCount 10

@interface JDNewestTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSDate *lastDate; /**< 最后一条数据的时间*/
@property (nonatomic, assign) NSInteger page;

@end

@implementation JDNewestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    [self configureTableView];
    
    __weak typeof(self) weakSelf = self;
    //先获取本地缓存的数据，然后再刷新取一次最新的
    [[TMCache sharedCache] objectForKey:kTMCacheKey_NewestObjects block:^(TMCache *cache, NSString *key, id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (object && [object isKindOfClass:[NSArray class]]) {
                NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:0];
                for (NSInteger i = 0; i < [object count]; i++) {
                    NSArray *array = (NSArray *)object;
                    JDNewestObject *object = (JDNewestObject *)[JDNewestObject objectWithDictionary:array[i]];
                    [objectArray addObject:object];
                }
                [weakSelf addDataSourceWithNewestObjects:objectArray filishBlock:nil];
            }
            [weakSelf.tableView.header beginRefreshing];
        });
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JDNewestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDNewestTableViewCell" forIndexPath:indexPath];
    
    JDNewestObject *object = self.dataSource[indexPath.section][indexPath.row];
    [cell configCellDataWithObject:object showDate:indexPath.row == 0];
    
    return cell;
}

#pragma mark - Private Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewestCtlToAddCasusCtl"]) {
         JDAddCasusTableViewController *addCtl = segue.destinationViewController;
        __weak typeof(self) weakSelf = self;
         addCtl.addSuccessBlock = ^(JDNewestObject *object){
             //添加新数据到第一条
             NSMutableArray *array;
             if (weakSelf.dataSource.count < 1) {
                 array = [NSMutableArray arrayWithCapacity:1];
                 [self.dataSource addObject:array];
             }else {
                 array = self.dataSource[0];
             }
             [array insertObject:object atIndex:0];
             [weakSelf.tableView reloadData];
         };
    }
}

- (void)configureTableView {
    //设置自动获取Cell高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    __weak typeof(self) weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataWithPage:1];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getDataWithPage:weakSelf.page + 1];
    }];
}

- (void)getDataWithPage:(NSInteger)page {
    AVQuery *query = [AVQuery queryWithClassName:NSStringFromClass([JDNewestObject class])];
    query.limit = kPageCount;
    query.skip = (page-1)*kPageCount;
    [query orderByDescending:@"createdAt"];
    
    __weak typeof(self) weakSelf = self;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //获取数据完成
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.domain];
            if (page == 1) {
                [weakSelf.tableView.header endRefreshing];
            }else {
                [weakSelf.tableView.footer endRefreshing];
            }
        }else {
            weakSelf.page = page;
            if (page == 1) {
                //是刷新
                weakSelf.lastDate = nil;
                [weakSelf.dataSource removeAllObjects];
                
                //缓存数据到本地
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
                for (NSInteger i = 0; i < objects.count; i++) {
                    JDNewestObject *object = objects[i];
                    NSDictionary *dic = [object dictionaryForObject];
                    [array addObject:dic];
                }
                [[TMCache sharedCache] setObject:array forKey:kTMCacheKey_NewestObjects];
            }
            
            [weakSelf addDataSourceWithNewestObjects:objects filishBlock:^{
                [weakSelf.tableView.header endRefreshing];
                
                if (objects.count == kPageCount) {
                    [weakSelf.tableView.footer endRefreshing];
                }else {
                    [weakSelf.tableView.footer endRefreshingWithNoMoreData];
                }
            }];
        }
    }];
}

//数据排序、分段
- (void)addDataSourceWithNewestObjects:(NSArray *)newestObjects filishBlock:(void(^)(void))filishBlock {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSInteger i = 0; i < newestObjects.count; i++) {
            JDNewestObject *object = newestObjects[i];
            NSDate *objectCreateAt = object.createdAt;
            NSDateFormatter *formatter = [JDDateFormatter shareInstance];
            formatter.dateFormat = @"YYYY-MM-dd";
            
            if ([[formatter stringFromDate:objectCreateAt] isEqualToString:[formatter stringFromDate:self.lastDate]]) {
                //跟上一次是同一天
                NSMutableArray *array;
                array = self.dataSource[self.dataSource.count-1];
                [array addObject:object];
            }else {
                //不是同一天。另分一个段
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
                [array addObject:object];
                self.lastDate = objectCreateAt;
                [self.dataSource addObject:array];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            !filishBlock ?: filishBlock();
        });
    });
}

#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
@end
