//
//  MJLoveSelectedView.m
//  Encounter
//
//  Created by 李明军 on 27/5/15.
//  Copyright (c) 2015年 KuiHe. All rights reserved.
//

#define selectedLoveStringDoneKnow                  @"保密"
#define selectedLoveStringSigle                     @"单身"
#define selectedLoveStringDoubleLoving              @"热恋中"
#define selectedLoveStringDoubleLoveHome            @"已婚"
#define selectedLoveStringSameSex                   @"同性"


#import "MJLoveSelectedView.h"
#import "MJConst.h"


@interface MJLoveSelectedView()

typedef enum
{
    kMJLoveSelectedViewDoneKnowBtnTag = 120,
    kMJLoveSelectedViewSigleManBtnTag,
    kMJLoveSelectedViewDoubleLovingBtnTag,
    kMJLoveSelectedViewDoubleLoveHomeBtnTag,
    kMJLoveSelectedViewSameSexBtnTag
}kMJLoveSelectedView;



/** 情感状态选择器       */
@property (weak, nonatomic) IBOutlet MJLoveSelectedView     *loveSelectedView;
/** 保密按钮            */
@property (weak, nonatomic) IBOutlet UIButton               *doneKnowBtn;
/** 单身按钮            */
@property (weak, nonatomic) IBOutlet UIButton               *sigleManBtn;
/** 热恋按钮            */
@property (weak, nonatomic) IBOutlet UIButton               *doubleLovingBtn;
/** 已婚按钮            */
@property (weak, nonatomic) IBOutlet UIButton               *doubleLoveHomeBtn;
/** 同性按钮            */
@property (weak, nonatomic) IBOutlet UIButton               *sameSexBtn;

@end


@implementation MJLoveSelectedView


- (instancetype)init{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MJLoveSelectedView"
                                              owner:self
                                            options:nil]
                firstObject];
        [self setTagForLoveBtn];
        [self determineWitchButtonSelected];
    }
    return self;
}



/**
 *  设置圆角
 */
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.loveSelectedView.layer.cornerRadius   = 15;
    self.loveSelectedView.layer.masksToBounds  = YES;
    // Drawing code
}

#pragma mark - 设置tag
/**
 *  设置情感状态选择按钮tag
 */
- (void)setTagForLoveBtn
{
    self.doneKnowBtn.tag                = kMJLoveSelectedViewDoneKnowBtnTag;
    self.sigleManBtn.tag                = kMJLoveSelectedViewSigleManBtnTag;
    self.doubleLovingBtn.tag            = kMJLoveSelectedViewDoubleLovingBtnTag;
    self.doubleLoveHomeBtn.tag          = kMJLoveSelectedViewDoubleLoveHomeBtnTag;
    self.sameSexBtn.tag                 = kMJLoveSelectedViewSameSexBtnTag;
}

#pragma mark - 取消所有按钮选择状态

/**
 *  取消所有按钮的选中状态
 */
- (void)setAllBtnSelectedNone
{
    self.doneKnowBtn.selected           = NO;
    self.sigleManBtn.selected           = NO;
    self.doubleLovingBtn.selected       = NO;
    self.doubleLoveHomeBtn.selected     = NO;
    self.sameSexBtn.selected            = NO;
}


#pragma mark - 控件事件监听

/**
 *  按钮点击事件
 *
 *  @param sender 被点击的按钮
 */
- (IBAction)btnClick:(UIButton *)sender
{
    //  1.0 定义局部字符串接收选中字符串
    NSString *selectedLoveString = nil;
    
    //  2.0 取消所有按钮选中状态
    [self setAllBtnSelectedNone];
    
    if ([MJUserDefault objectForKey:userDefaultLoveSelectedStr]) {
        [MJUserDefault removeObjectForKey:userDefaultLoveSelectedStr];
    }
    //  3.0 根据按钮tag设置选中状态
    switch (sender.tag)
    {
        case kMJLoveSelectedViewDoneKnowBtnTag:
        {
            selectedLoveString                  = selectedLoveStringDoneKnow;
            break;
        }
        case kMJLoveSelectedViewSigleManBtnTag:
        {
            selectedLoveString                  = selectedLoveStringSigle;
            break;
        }
        case kMJLoveSelectedViewDoubleLovingBtnTag:
        {
            selectedLoveString                  = selectedLoveStringDoubleLoving;
            break;
        }
        case kMJLoveSelectedViewDoubleLoveHomeBtnTag:
        {
            selectedLoveString                  = selectedLoveStringDoubleLoveHome;
            break;
        }
        case kMJLoveSelectedViewSameSexBtnTag:
        {
            selectedLoveString                  = selectedLoveStringSameSex;
            break;
        }
        default:
        {
            break;
        }
    }
    
    
    //  4.0 设置代理方法
    if ([self.delegate respondsToSelector:@selector(loveSelectedView:selectedLoveString:)])
    {
        [self.delegate loveSelectedView:self selectedLoveString:selectedLoveString];
    }
    
    
    //  5.0 保存选中用户偏好
    [MJUserDefault setObject:selectedLoveString forKey:userDefaultLoveSelectedStr];
}


#pragma mark - 判断历史选中状态
/**
 *  判断哪个按钮选中
 */
- (void)determineWitchButtonSelected
{
    //  1.0 取消所有按钮选中状态
    [self setAllBtnSelectedNone];
    
    //  2.0 从用户偏好中取出userDefaultLoveSelectedStr对应的值
    NSString *userDefaultLoveStr            = [MJUserDefault objectForKey:userDefaultLoveSelectedStr];
    //  2.1.1 若为保密，则保密按钮选中
    if ([userDefaultLoveStr isEqualToString:selectedLoveStringDoneKnow])
    {
        self.doneKnowBtn.selected           = YES;
    }
    //  2.1.2 若为单身，则单身按钮选中
    else if ([userDefaultLoveStr isEqualToString:selectedLoveStringSigle])
    {
        self.sigleManBtn.selected           = YES;
    }
    //  2.1.3 若为热恋，则热恋按钮选中
    else if ([userDefaultLoveStr isEqualToString:selectedLoveStringDoubleLoving])
    {
        self.doubleLovingBtn.selected       = YES;
    }
    //  2.1.4 若为已婚，则已婚按钮选中
    else if ([userDefaultLoveStr isEqualToString:selectedLoveStringDoubleLoveHome])
    {
        self.doubleLoveHomeBtn.selected     = YES;
    }
    //  2.1.5 若为同性，则同性按钮选中
    else if ([userDefaultLoveStr isEqualToString:selectedLoveStringSameSex])
    {
        self.sameSexBtn.selected            = YES;
    }
    //  2.1.6 若为空或其他，则默认保密按钮选中
    else
    {
        self.doneKnowBtn.selected           = YES;
    }
}

@end
