//
//  WMTextView.m
//  WMTextView
//
//  Created by David on 16/7/29.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "WMTextView.h"

@interface WMTextView ()

@property (nonatomic, weak) UILabel * placeHoderLabel;


@end


@implementation WMTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 垂直方向上永远有弹簧效果
        self.alwaysBounceVertical = YES;
        
        UILabel * placeHoderLabel = [[UILabel alloc] init];
        placeHoderLabel.numberOfLines = 0;
        placeHoderLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:placeHoderLabel];
        
        UILabel * countLabel = [[UILabel alloc] init];
        countLabel.textColor = [UIColor colorWithHexString:@"#414141"];
        countLabel.text = @"0/300字";
        countLabel.font = [UIFont systemFontOfSize:14];
        countLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:countLabel];
        

        self.placeHoderLabel = placeHoderLabel;
        self.countLabel = countLabel;
        self.placehoderColor = [UIColor lightGrayColor];
        _placeHoderLabel.font = [UIFont systemFontOfSize:14];
        [self setKeyBorde];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
        
        [self setLayout];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)setIsHiddenCountLabel:(BOOL)isHiddenCountLabel
{
    _isHiddenCountLabel = isHiddenCountLabel;
    if (_isHiddenCountLabel == YES) {
        _countLabel.hidden = YES;
    }
}

- (void)setLayout
{
    _countLabel.sd_layout
    .rightSpaceToView(self, 10)
    .bottomSpaceToView(self, 5)
    .widthIs(150)
    .heightIs(21);
}

- (void)textDidChange
{
    self.placeHoderLabel.hidden = self.hasText;
    NSInteger length = [self convertToInt:self.text];
    _countLabel.text = [NSString stringWithFormat:@"%ld/300字", (long)length];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self textDidChange];
}

- (void)setPlacehoder:(NSString *)placehoder
{
    _placehoder = [placehoder copy];
    self.placeHoderLabel.text = _placehoder;
}



- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeHoderLabel.font = [UIFont systemFontOfSize:15];
    // 重新计算子控件的frame
    [self setNeedsLayout];
}

- (void)setPlacehoderColor:(UIColor *)placehoderColor
{
    _placehoderColor = placehoderColor;
    _placeHoderLabel.textColor = placehoderColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placeHoderLabel.x = 5;
    self.placeHoderLabel.y = 8;
    self.placeHoderLabel.width = self.width - 2 * self.placeHoderLabel.x;
    // 根据文字计算label的高度
    CGSize placehoderSize = [self.placeHoderLabel.text boundingRectWithSize:CGSizeMake(self.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    self.placeHoderLabel.height = placehoderSize.height;
}


- (NSInteger)getToInt:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}

// 计算中英混合字符串的长度
- (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

- (void)setKeyBorde
{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem* button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem* button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(resignKeyboard)];
    NSArray* buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    
    [topView setItems:buttonsArray];
    [self setInputAccessoryView:topView];
}

- (void)resignKeyboard
{
    [self resignFirstResponder];
}

@end
