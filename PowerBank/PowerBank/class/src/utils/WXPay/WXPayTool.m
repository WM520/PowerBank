//
//  WXPayTool.m
//  DHETC
//
//  Created by zlx on 16/7/28.
//  Copyright © 2016年 yujiuyin. All rights reserved.
//

#import "WXPayTool.h"
#import "WXApi.h"
#import "DataMD5.h"
#import "WXPayModel.h"
//#import "getIPhoneIP.h"
//#import "XMLDictionary.h"
//#import "payRequsestHandler.h"
//#import "WeiChatXmlHandle.h"
//#import "CommonPayParam.h"

@implementation WXPayTool

static WXPayTool *_wxInstance;

+ (instancetype)shareWXPayTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _wxInstance = [[WXPayTool alloc]init];
        
    });
    return _wxInstance;
}

//微信在线支付

- (void)onlineWXPay:(NSString *)orderId info:(NSDictionary *)infoDic withCompletionBlock:(WXPayHandleBlock)handleBlock
{
    self.wxpayHandleBlock = handleBlock;
    if (infoDic) {
        
        WXPayModel *model = [[WXPayModel alloc]initWithDictionary:infoDic];
        PayReq *request = [[PayReq alloc] init];
        if(model ) {
            request.partnerId = FormatterString(model.partnerid);
            request.prepayId= FormatterString(model.prepayid);
            request.package = FormatterString(model.packagestr);
            request.nonceStr= FormatterString(model.noncestr);
            request.timeStamp = [FormatterString(model.timestamp) intValue];
            request.sign= FormatterString(model.sign);
            NSLog(@"%@",model.prepayid);
//            DataMD5 *md5 = [[DataMD5 alloc] init];
//            request.sign=[md5 createMD5SingForPay:WXAPPID partnerid:request.partnerId==nil?@"":request.partnerId prepayid:request.prepayId==nil?@"":request.prepayId package:request.package==nil?@"":request.package noncestr:request.nonceStr==nil?@"":request.nonceStr timestamp:request.timeStamp];
            [WXApi sendReq:request];
        }

    }
}


-(void) onResp:(BaseResp*)resp
{
    //这里判断回调信息是否为 支付
    NSLog(@"使用代理-----%d",resp.errCode);
    if([resp isKindOfClass:[PayResp class]]){
        switch (resp.errCode) {
            case WXSuccess:
                self.wxpayHandleBlock(WXPayResultTypeSuccess);
                break;
                
            case WXErrCodeUserCancel:
                self.wxpayHandleBlock(WXPayResultTypeCanceled);
                break;
                
            default:
                self.wxpayHandleBlock(WXPayResultTypeFailed);
                break;
        }
    }
}






@end
