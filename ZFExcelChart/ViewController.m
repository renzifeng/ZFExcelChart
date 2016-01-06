//
//  ViewController.m
//  ZFExcelChart
//
//  Created by 任子丰 on 16/1/6.
//  Copyright © 2016年 任子丰. All rights reserved.
//

#import "ViewController.h"
#import "ZFDataTableView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ItemWidth ScreenWidth/9
#define ItemHeight 44
#define ScrollHeight (ItemHeight*6)

@interface ViewController ()<ZFScrollDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIView *headView;
/** x方向数据*/
@property (nonatomic, strong) NSArray *arrX;
/** y方向数据*/
@property (nonatomic, strong) NSArray *arrY;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSDictionary *dataDic = [rootDict objectForKey:@"data"];
    
    //x方向数据
    _arrX = [dataDic objectForKey:@"table_titles"];
    
    //y方向数据
    _arrY = [dataDic objectForKey:@"list_datas"];
    
    
    //第一列tableView父视图
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, ItemWidth, ScrollHeight)];
    _headView.backgroundColor = [UIColor grayColor];
    _headView.userInteractionEnabled = YES;
    //设置边框，形成表格
    _headView.layer.borderWidth = .5f;
    _headView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_headView];
    
    //可左右滑动tableView父视图
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(ItemWidth, 30, ScreenWidth-ItemWidth, ScrollHeight)];
    _scroll.contentSize = CGSizeMake((_arrX.count-1)*ItemWidth, _arrY.count*ItemHeight);
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.bounces = NO;
    _scroll.delegate = self;
    _scroll.backgroundColor = [UIColor lightGrayColor];
    //设置边框，形成表格
    _scroll.layer.borderWidth = .5f;
    _scroll.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self.view addSubview:_scroll];
    
    
    //第一列表
    ZFDataTableView *tableView = [[ZFDataTableView alloc] initWithFrame:_headView.bounds style:UITableViewStylePlain];
    
    NSMutableArray *titleArr1 = [NSMutableArray array];
    for (NSDictionary *dic in _arrY)
    {
        NSString *titleStr = [dic objectForKey:@"name"];
        [titleArr1 addObject:titleStr];
    }
    tableView.titleArr = titleArr1;
    
    tableView.headerStr = [_arrX[0] objectForKey:@"name1"];
    tableView.scroll_delegate = self;
    [_headView addSubview:tableView];
    
    
    for (int i = 0; i < _arrX.count-1; i++)
    {
        ZFDataTableView *tableView = [[ZFDataTableView alloc] initWithFrame:CGRectMake(ItemWidth*i, 0, ItemWidth, ScrollHeight) style:UITableViewStylePlain];
        
        //x方向 取出key对应的字符串名字
        NSString *xkey = [NSString stringWithFormat:@"name%d",i+2];
        NSString *xname = [_arrX[i+1] objectForKey:xkey];
        tableView.headerStr = xname;
        
        //y方向
        NSMutableArray *titleArr2 = [NSMutableArray array];
        for (int j=0; j<_arrY.count; j++)
        {
            NSString *ykey = [NSString stringWithFormat:@"date%d",i+1];
            NSString *yname = [_arrY[j] objectForKey:ykey];
            [titleArr2 addObject:yname];
        }
        tableView.titleArr = titleArr2;
        [tableView reloadData];
        tableView.scroll_delegate = self;
        [_scroll addSubview:tableView];
    }
}

#pragma mark - ZFScrollDelegate

-(void)dataTableViewContentOffSet:(CGPoint)contentOffSet
{
    for (UIView *subView in _scroll.subviews)
    {
        if ([subView isKindOfClass:[ZFDataTableView class]])
        {
            [(ZFDataTableView *)subView setTableViewContentOffSet:contentOffSet];
        }
    }
    
    for (UIView *subView in _headView.subviews)
    {
        [(ZFDataTableView *)subView setTableViewContentOffSet:contentOffSet];
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint p = scrollView.contentOffset;
    NSLog(@"%@",NSStringFromCGPoint(p));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
