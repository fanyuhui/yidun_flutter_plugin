#import "WangyiYidunFlutterPlugin.h"

@implementation WangyiYidunFlutterPlugin

+ (WangyiYidunFlutterPlugin *)sharedInstance {
    static dispatch_once_t onceToken = 0;
    static WangyiYidunFlutterPlugin *sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[WangyiYidunFlutterPlugin alloc] init];
    });
    
    return sharedObject;
}

+(void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"wangyi_yidun_flutter_plugin"
            binaryMessenger:[registrar messenger]];
  WangyiYidunFlutterPlugin* instance = [[WangyiYidunFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterViewController *view = (FlutterViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
     
    FlutterEventChannel* eventChannel = [FlutterEventChannel eventChannelWithName:@"yd_captcha_flutter_event_channel" binaryMessenger:view.binaryMessenger];
    [eventChannel setStreamHandler:[WangyiYidunFlutterPlugin sharedInstance]];
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                      eventSink:(FlutterEventSink)events {
      if (events) {
          [WangyiYidunFlutterPlugin sharedInstance].eventSink = events;
      }

    return nil;
}
-(void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    
}

   /// flutter不再接收
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
   return nil;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"show" isEqualToString:call.method]) {
        result(@"成功");
    } else if ([@"setup" isEqualToString:call.method]) {
        [self setup:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}
- (void)setup:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"setup:");
    NSDictionary *arguments = call.arguments;
    [self showCaptchaWith:arguments];
}

- (void)showCaptchaWith:(NSDictionary *)arguments {
    self.manager =  [NTESVerifyCodeManager getInstance];
    if (self.manager) {
        
        // 如果需要了解组件的执行情况,则实现回调
        self.manager.delegate = self;
        
        // captchaid的值是每个产品从后台生成的,比如 @"a05f036b70ab447b87cc788af9a60974"
        
        // 传统验证码 @"deecf3951a614b71b4b1502c072be1c1";
        NSString *captchaid =[self getText:arguments text:@"appKey"];
        self.manager.mode = NTESVerifyCodeNormal;
        
        // 无感知验证码
//        NSString *captchaid = @"6a5cab86b0eb4c309ccb61073c4ab672";
//        self.manager.mode = NTESVerifyCodeBind;
        
        [self.manager configureVerifyCode:captchaid timeout:7.0];
        
        // 设置语言
        self.manager.lang = NTESVerifyCodeLangCN;
        
        // 设置透明度
        self.manager.alpha = 0.3;
        
        // 设置颜色
        self.manager.color = [UIColor blackColor];
        
        // 设置frame
        self.manager.frame = CGRectNull;
        
        // 是否开启降级方案
        self.manager.openFallBack = YES;
        self.manager.fallBackCount = 3;
        
        // 是否隐藏关闭按钮
        self.manager.closeButtonHidden = [self getCloseButtonHidden:arguments];
    
        self.manager.slideIconURL = [self getText:arguments text:@"slideIconURL"];
        self.manager.slideIconMovingURL = [self getText:arguments text:@"slideIconMoving"];
        self.manager.slideIconErrorURL = [self getText:arguments text:@"slideIconError"];
        
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"icon_loading" ofType:@"gif"];
        NSData *imageData = [NSData dataWithContentsOfFile:bundlePath];
        [self.manager configLoadingImage:nil gifData:imageData];
        [self.manager configLoadingText:@"安全验证"];
        
        // 显示验证码
        [self.manager openVerifyCodeView:nil];
    }
}

- (NSString *)getText:(NSDictionary *)arguments text:(NSString *)text{
    NSString *temp = arguments[text];
    if ([temp isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return temp;
}
- (BOOL)getCloseButtonHidden:(NSDictionary *)arguments{
    if ([arguments[@"closeButton"] isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return arguments[@"closeButton"];
}

#pragma mark - NTESVerifyCodeManagerDelegate
/**
 * 验证码组件初始化完成
 */
- (void)verifyCodeInitFinish{
    NSLog(@"收到初始化完成的回调");
//    self.result([NSNumber numberWithBool:YES]);
}

/**
 * 验证码组件初始化出错
 *
 * @param message 错误信息
 */
- (void)verifyCodeInitFailed:(NSString *)message{
    NSLog(@"收到初始化失败的回调:%@",message);
    if ([WangyiYidunFlutterPlugin sharedInstance].eventSink) {
        [WangyiYidunFlutterPlugin sharedInstance].eventSink(message);
    }
}

/**
 * 完成验证之后的回调
 *
 * @param result 验证结果 BOOL:YES/NO
 * @param validate 二次校验数据，如果验证结果为false，validate返回空
 * @param message 结果描述信息
 *
 */
- (void)verifyCodeValidateFinish:(BOOL)result validate:(NSString *)validate message:(NSString *)message{
    NSDictionary *dict = @{@"result":@(result),@"validate":validate ? : @"",@"msg":message ? : @""};
    if (result) {
        if ([WangyiYidunFlutterPlugin sharedInstance].eventSink) {
            [WangyiYidunFlutterPlugin sharedInstance].eventSink(dict);
        }
    } else {
        if ([WangyiYidunFlutterPlugin sharedInstance].eventSink) {
            [WangyiYidunFlutterPlugin sharedInstance].eventSink(dict);
        }
    }
    NSLog(@"收到验证结果的回调:(%d,%@,%@)", result, validate, message);
}

- (void)verifyCodeCloseWindow:(NTESVerifyCodeClose)close {
    if ([WangyiYidunFlutterPlugin sharedInstance].eventSink) {
        [WangyiYidunFlutterPlugin sharedInstance].eventSink([NSNumber numberWithInt:(int)close]);
    }
}


@end
