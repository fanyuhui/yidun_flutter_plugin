#import <Flutter/Flutter.h>
#import <VerifyCode/NTESVerifyCodeManager.h>

@interface WangyiYidunFlutterPlugin : NSObject<FlutterPlugin,NTESVerifyCodeManagerDelegate,FlutterStreamHandler>

@property(nonatomic, strong) NTESVerifyCodeManager *manager;
@property (nonatomic, strong) FlutterEventSink eventSink;

+ (WangyiYidunFlutterPlugin *)sharedInstance;

-(void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;

@property (nonatomic, copy) NSString *captchaId;
@end
