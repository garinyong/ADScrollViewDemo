//
//  ViewController.m
//  ADScrollViewDemo
//
//  Created by xjiang on 15/10/26.
//  Copyright (c) 2015年 xjiang. All rights reserved.
//

#import "ViewController.h"
#define   RGB(r,g,b)    [UIColor colorWithRed:r * 1.0 /255  green:g *1.0 / 255 blue:b *1.0 / 255 alpha:1.0]

@interface ViewController ()<UIScrollViewDelegate>
{
    
    UIPageControl   *pageCtr;
    UIScrollView   *scrollView;
    CGSize         winSize;
    NSTimer        *timer;
    
    NSMutableArray   *imgArray;
    NSInteger      totalPage;
    NSInteger      currentImageIndex;
    
    
    
    UIImageView *leftImageView;
    UIImageView *centerImageView;
    UIImageView *rightImageView;

    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
      winSize = [UIScreen mainScreen].bounds.size;
    
    [self initData];
    
    [self initView];
    
    [self addImageViews];
     
    [self setDefaultImage];
    
    
}

-(void)initData
{
    totalPage = 8;
    
    imgArray = [NSMutableArray array];
    for(int i =0 ;i < totalPage ; i++ )
    {
        UIImage  *image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d",i]];
        [imgArray addObject:image];
  
    }
}

-(void)initView
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, winSize.width, 200)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(winSize.width * 3, 200);
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    pageCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, winSize.width, 20)];
    pageCtr.center = CGPointMake(winSize.width / 2, CGRectGetMaxY(scrollView.frame) - 10);
    [self.view addSubview:pageCtr];
    pageCtr.backgroundColor = [UIColor clearColor];
    pageCtr.numberOfPages = totalPage;
    pageCtr.userInteractionEnabled = YES;
    pageCtr.currentPageIndicatorTintColor = [UIColor redColor];
    pageCtr.pageIndicatorTintColor = [UIColor yellowColor];
    
    [pageCtr addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    

}
#pragma mark 添加图片三个控件
-(void)addImageViews{
    leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,  winSize.width, 200)];
    leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    [scrollView addSubview:leftImageView];
    centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(winSize.width, 0, winSize.width,  200)];
    centerImageView.contentMode=UIViewContentModeScaleAspectFit;
    [scrollView addSubview:centerImageView];
    rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2 * winSize.width, 0, winSize.width, 200)];
    rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    [scrollView addSubview:rightImageView];
}

#pragma mark 设置默认显示图片
-(void)setDefaultImage{
    //加载默认图片
    leftImageView.image =  [imgArray objectAtIndex:totalPage - 1];
    centerImageView.image = [imgArray objectAtIndex:0];
    rightImageView.image = [imgArray objectAtIndex:1];
    currentImageIndex=0;
    //设置当前页
    pageCtr.currentPage= currentImageIndex;
    
}




-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1{
   
    //重新加载图片
    [self reloadImage];

    //移动到中间
    [scrollView1 setContentOffset:CGPointMake(winSize.width, 0) animated:NO];
    
     pageCtr.currentPage = currentImageIndex;
    
 
    
}

#pragma mark 重新加载图片
-(void)reloadImage{
    NSInteger leftImageIndex,rightImageIndex;
    CGPoint offset = [scrollView contentOffset];
    
    
    if (offset.x>winSize.width) { //向左滑动
        currentImageIndex=(currentImageIndex+1) % totalPage;
        
    }else if(offset.x<winSize.width){ //向右滑动
        currentImageIndex = (currentImageIndex + totalPage - 1) %  totalPage;
    }
    
    
    //UIImageView *centerImageView=(UIImageView *)[_scrollView viewWithTag:2];
    centerImageView.image= [imgArray objectAtIndex:currentImageIndex];
    
    //重新设置左右图片
    leftImageIndex = (currentImageIndex + totalPage-1) % totalPage;
    rightImageIndex=( currentImageIndex+1) % totalPage;
    leftImageView.image=  [imgArray objectAtIndex:leftImageIndex];
    rightImageView.image=  [imgArray objectAtIndex:rightImageIndex];
    
}



-(void)changePage:(UIPageControl *)sender
{
 
    CGSize viewSize = scrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [scrollView scrollRectToVisible:rect animated:YES];
    
}
@end
