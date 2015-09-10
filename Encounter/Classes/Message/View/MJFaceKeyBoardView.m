//
//  MJFaceKeyBoardView.m
//  Encounter
//
//  Created by 李明军 on 18/6/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#define systemSize [UIScreen mainScreen].bounds.size

#define faceWidth       44 //  表情宽度
#define pageCountNum    28 //  每页总表情数
#define pageCols        7  //  每排表情数

#define FACE_COUNT_ALL  81 //  总共多少表情
#define FACE_COUNT_PAGE 3  //  总共多少页

#import "MJFaceKeyBoardView.h"
#import "MJFaceImgModel.h"

@interface MJFaceKeyBoardView()<UIScrollViewDelegate>


/** 表情模型数组 */
@property (nonatomic,strong) NSArray *faceArray;
/** 表情滚动盘 */
@property (nonatomic,strong) UIScrollView *scrollView;
/** 分页控制器 */
@property (nonatomic,strong) UIPageControl *pageControl;


@end


@implementation MJFaceKeyBoardView


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        //表情盘
        CGFloat x = (systemSize.width - 320) * 0.5;
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(x, 0, 320, 190)];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(3 * 320, 190);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;

    }
    return _scrollView;
}




- (NSArray *)faceArray
{
    if (!_faceArray) {
        
        _faceArray = [MJFaceImgModel faceModels];
    }
    return _faceArray;
}

/**
 *  初始化添加表情按钮
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
       
        [self setBackgroundColor:[UIColor whiteColor]];
        for (NSInteger i = 0; i < self.faceArray.count; i++)
        {
            
            MJFaceImgModel *faceImgModel = self.faceArray[i];
            
            UIButton *btn   = [[UIButton alloc] init];
            btn.tag         = i;
            
            [btn setImage:[UIImage imageNamed:faceImgModel.imgName]
                 forState:UIControlStateNormal];
            
            [btn addTarget:self
                    action:@selector(faceBtnClick:)
          forControlEvents:UIControlEventTouchUpInside];
            
            //  第几页
            NSInteger pageNum = (i / pageCountNum) + 1;
            //  第几排
            NSInteger colsNum = (i % pageCountNum) / pageCols;
            //  第几列
            NSInteger rowNum  = (i % pageCountNum) % pageCols;
            
            //  每个表情之间的间距
            CGFloat margin = (320 - faceWidth * pageCols) / (pageCols + 1);
            
            CGFloat btnX;
            CGFloat btnY;
         
            btnX = margin * pageNum + (faceWidth + margin) * rowNum + 320 * (pageNum - 1);
            
            btnY = margin + (faceWidth + margin) * colsNum;
            
            btn.frame = CGRectMake(btnX, btnY, faceWidth, faceWidth);
            
            [self.scrollView addSubview:btn];

        }
        
        
        CGFloat x = (systemSize.width - 50) * 0.5;
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake( x, 190, 50, 10)];
        
        [_pageControl addTarget:self
                         action:@selector(pageChange:)
               forControlEvents:UIControlEventValueChanged];
        
        _pageControl.numberOfPages = 3;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
//        self.frame = CGRectMake(0, 0, systemSize.width * 4, capping * 2 + faceWidth * 3 + margin * 2);
    }
    return self;
}


//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self.pageControl setCurrentPage:self.scrollView.contentOffset.x / 320];
    [self.pageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {
    
    [self.scrollView setContentOffset:CGPointMake(self.pageControl.currentPage * 320, 0) animated:YES];
    [self.pageControl setCurrentPage:self.pageControl.currentPage];
}






/**
 *  表情点击事件
 *
 *  @param sender
 */
- (void)faceBtnClick:(UIButton *)sender
{
    NSInteger i = sender.tag;
    MJFaceImgModel *faceImgModel = self.faceArray[i];
    
    if ([self.delegate respondsToSelector:@selector(faceKeyBoardDidSelectedFaceBtnWithFaceBtnStr:)])
    {
        [self.delegate faceKeyBoardDidSelectedFaceBtnWithFaceBtnStr:faceImgModel.imgName];
    }
    
}


@end
