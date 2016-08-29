//
//  PPGViewController.m
//  CrazyDiary
//
//  Created by ss-iOS-LLY on 16/8/25.
//  Copyright © 2016年 lilianyou. All rights reserved.
//

#import "PPGViewController.h"
#import <QuartzCore/QuartzCore.h>

#define FRAMES_PER_SECOND 30
@interface PPGViewController ()
{
    UILabel *_rateLabel;
    BOOL isShowRate;
}
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) UIView *showView;
@end

@implementation PPGViewController
void RGBtoHSV(float r,float g, float b, float *h, float* s, float *v){
    float min, max,delta;
    min = MIN(r, MIN(g, b));
    max = MAX(r, MAX(g, b));
    *v = max;
    delta = max - min;
    if (max != 0) {
        *s = delta /max;
    } else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    
    if (r == max) {
        *h = (g - b)/delta;
    } else if (g == max){
        *h = 2 + (b - r)/delta;
    }else {
        *h = 4 + (r - g) / delta;
    }
    *h *= 60;     // degrees
    if (*h < 0) {
        *h += 360;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isShowRate = YES;
    [self setupAVCapture];
    // UI
    [self showHeartRate];
    
}

#pragma mark --setup
- (void)setupAVCapture
{
    [self configurationCaptureDevice];
    _session = [AVCaptureSession new];
    [_session beginConfiguration];
    
    //建立输入流
    NSError *error = nil;
    AVCaptureDevice *device = [self getBackCameraDevice];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"DeviceInput  error:%@",error.localizedDescription);
        return;
    }
    
    // 建立输出流
    AVCaptureVideoDataOutput *videoDataOutput =[AVCaptureVideoDataOutput new];
    NSNumber *BGRA32PixelFormat = [NSNumber numberWithInt:kCVPixelFormatType_32BGRA];
    NSDictionary *rgbOutputSetting = [NSDictionary dictionaryWithObject:BGRA32PixelFormat forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings:rgbOutputSetting];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];//抛弃延迟的帧
    dispatch_queue_t videoDataOutputQueue = dispatch_queue_create("videoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
    
    if ([_session canAddInput:deviceInput]) {
        [_session addInput:deviceInput];
    }
    if ([_session canAddOutput:videoDataOutput]) {
        [_session addOutput:videoDataOutput];
    }
    
    //
    AVCaptureConnection *connection =[videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    // 1秒6帧就能测试心跳
    device.activeVideoMinFrameDuration = CMTimeMake(1, FRAMES_PER_SECOND);
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    [_session commitConfiguration];
    [_session startRunning];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self stopAVCapture];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)stopAVCapture
{
    [_session stopRunning];
    _session = nil;
    _points = nil;
}
- (AVCaptureDevice *)getBackCameraDevice
{
    NSArray *devices= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionBack) {
            return device;
        }
    }
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return device;
}
- (void)configurationCaptureDevice
{
    AVCaptureDevice *device = [self getBackCameraDevice];
    if ([device isTorchModeSupported:AVCaptureTorchModeOn]) {
        NSError *error = nil;
        [device lockForConfiguration:&error];
        if (error) {
            return;
        }
        //白平衡，对焦，降低闪关灯的亮度
        [device setTorchMode:AVCaptureTorchModeOn];
        [device unlockForConfiguration];
    }
}

#pragma mark --AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    //读取图像缓存
    CVPixelBufferRef imageBffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBffer, 0);
    
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBffer);
    uint8_t *buf = (uint8_t *)CVPixelBufferGetBaseAddress(imageBffer);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBffer);
    size_t width = CVPixelBufferGetWidth(imageBffer);
    size_t height = CVPixelBufferGetHeight(imageBffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    // 缺少心率算法计算等
    // kCVPixelFormatType_32BGRA     B G R A
    float  r = 0, g = 0, b = 0;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width * 4; x += 4) {
            b += buf[x];
            g += buf[x + 1];
            r += buf[x + 2];
        }
        buf += bytesPerRow;
    }
    /*
     r /= 255 *(float)(width *height);
     g /= 255 *(float)(width *height);
     b /= 255 *(float)(width *height);
     UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
     CGFloat hue, sat, bright;
     [color getHue:&hue saturation:&sat brightness:&bright alpha:nil];
     NSLog(@"-hue---%f---",hue);
     */
    
    r /= 255 *(float)(width *height);
    g /= 255 *(float)(width *height);
    b /= 255 *(float)(width *height);
    float h = 0.f, s = 0.f, v = 0.f;
    RGBtoHSV(r, g, b, &h, &s, &v);
    
    // 用H值来作为特征值
    static float lastH = 0;
    float highPassValue = h -lastH;
    lastH = h;
    float lastHightPassValue = 0;
    float lowPassValue = (lastHightPassValue + highPassValue) / 2;
    lastHightPassValue = highPassValue;
    NSLog(@"----%f",lowPassValue);
    
    // 进行预处理，譬如进行滤波，过滤掉一些噪声，可以参考一篇博客：巴特沃斯滤波器；http://blog.csdn.net/shengzhadon/article/details/46803401
    
    if (!_points) {
        _points = [NSMutableArray new];
    }
    //    if (lowPassValue <= 1.f && lowPassValue >= 0.0f) {
    [_points insertObject:[NSNumber numberWithFloat:lowPassValue] atIndex:0];
    //    }
    
    while (_points.count > SCREENWIDTH / 2.f) {
        [_points removeLastObject];
    }
    
    NSMutableArray *bandpassFilteredItems = [self butterworthBandpassFilter:_points];
    NSMutableArray *smoothBandpassItems = [self medianSmoothing:bandpassFilteredItems];
    
    if (_points.count) {
        [self render:context smoothBandpassItems:smoothBandpassItems];
    }
    if (isShowRate && (smoothBandpassItems.count % FRAMES_PER_SECOND == 0) && smoothBandpassItems.count > 60 ) {
        _rateLabel.text =[NSString stringWithFormat:@"%d",[self getHeartRateWithSmoothBandpassItems:smoothBandpassItems]];
        
    }
    
    
    // ＊＊转成位图以便绘制到Layer上
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    id renderImage = CFBridgingRelease(quartzImage);
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [CATransaction setDisableActions:YES];
        [CATransaction begin];
        _showView.layer.contents = renderImage;
        [CATransaction commit];
    });
}

// TODO:带通滤波
- (NSMutableArray *)butterworthBandpassFilter:(NSArray *)inputData
{
    const int NZEROS = 8;
    const int NPOLES = 8;
    static float xv[NZEROS+1], yv[NPOLES+1];
    
    // http://www-users.cs.york.ac.uk/~fisher/cgi-bin/mkfscript
    // Butterworth Bandpass filter
    // 4th order
    // sample rate - varies between possible camera frequencies. Either 30, 60, 120, or 240 FPS
    // corner1 freq. = 0.667 Hz (assuming a minimum heart rate of 40 bpm, 40 beats/60 seconds = 0.667 Hz)
    // corner2 freq. = 4.167 Hz (assuming a maximum heart rate of 250 bpm, 250 beats/60 secods = 4.167 Hz)
    // Bandpass filter was chosen because it removes frequency noise outside of our target range (both higher and lower)
    double dGain = 1.232232910e+02;
    
    NSMutableArray *outputData = [[NSMutableArray alloc] init];
    for (NSNumber *number in inputData)
    {
        double input = number.doubleValue;
        
        xv[0] = xv[1]; xv[1] = xv[2]; xv[2] = xv[3]; xv[3] = xv[4]; xv[4] = xv[5]; xv[5] = xv[6]; xv[6] = xv[7]; xv[7] = xv[8];
        xv[8] = input / dGain;
        yv[0] = yv[1]; yv[1] = yv[2]; yv[2] = yv[3]; yv[3] = yv[4]; yv[4] = yv[5]; yv[5] = yv[6]; yv[6] = yv[7]; yv[7] = yv[8];
        yv[8] =   (xv[0] + xv[8]) - 4 * (xv[2] + xv[6]) + 6 * xv[4]
        + ( -0.1397436053 * yv[0]) + (  1.2948188815 * yv[1])
        + ( -5.4070037946 * yv[2]) + ( 13.2683981280 * yv[3])
        + (-20.9442560520 * yv[4]) + ( 21.7932169160 * yv[5])
        + (-14.5817197500 * yv[6]) + (  5.7161939252 * yv[7]);
        
        [outputData addObject:@(yv[8])];
    }
    
    return outputData;
}

// Find the peaks in our data - these are the heart beats.
// At a 30 Hz detection rate, assuming 250 max beats per minute, a peak can't be closer than 7 data points apart.
- (int)peakCount:(NSArray *)inputData
{
    if (inputData.count == 0)
    {
        return 0;
    }
    
    int count = 0;
    
    for (int i = 3; i < inputData.count - 3;)
    {
        if (inputData[i] > 0 &&
            [inputData[i] doubleValue] > [inputData[i-1] doubleValue] &&
            [inputData[i] doubleValue] > [inputData[i-2] doubleValue] &&
            [inputData[i] doubleValue] > [inputData[i-3] doubleValue] &&
            [inputData[i] doubleValue] >= [inputData[i+1] doubleValue] &&
            [inputData[i] doubleValue] >= [inputData[i+2] doubleValue] &&
            [inputData[i] doubleValue] >= [inputData[i+3] doubleValue]
            )
        {
            count = count + 1;
            i = i + 4;
        }
        else
        {
            i = i + 1;
        }
    }
    
    return count;
}
// Smoothed data helps remove outliers that may be caused by interference, finger movement or pressure changes.
// This will only help with small interference changes.
// This also helps keep the data more consistent.
- (NSMutableArray *)medianSmoothing:(NSMutableArray *)inputData
{
    NSMutableArray *newData = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < inputData.count; i++)
    {
        if (i == 0 ||
            i == 1 ||
            i == 2 ||
            i == inputData.count - 1 ||
            i == inputData.count - 2 ||
            i == inputData.count - 3)        {
            [newData addObject:inputData[i]];
        }
        else
        {
            NSArray *items = [@[
                                inputData[i-2],
                                inputData[i-1],
                                inputData[i],
                                inputData[i+1],
                                inputData[i+2],
                                ] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
            
            [newData addObject:items[2]];
        }
    }
    
    return newData;
}

//TODO:计算心率
- (int)getHeartRateWithSmoothBandpassItems:(NSMutableArray *)smoothBandpassItems
{
    float heartRate = 0.f;
    if (smoothBandpassItems.count % FRAMES_PER_SECOND == 0) {
        int peakCount = [self peakCount:smoothBandpassItems];
        if (peakCount < 50) {
            return 0;
        }
        float secondsPassed = smoothBandpassItems.count / FRAMES_PER_SECOND; // 每一帧每一秒的采集点数
        float percentage = secondsPassed / 60; // 1/60s的采集点数
        heartRate = peakCount / percentage; // 每分钟的峰值
    }
    isShowRate = NO;
    return  heartRate;
}
- (void)render:(CGContextRef)context smoothBandpassItems:(NSMutableArray *)smoothBandpassItems
{
    CGRect bounds = _showView.bounds;
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2);
    CGContextBeginPath(context);
    
    // 判断屏幕分辨率 @x1 ,@x2, @x3
    CGFloat scale = [[UIScreen mainScreen]scale];
    
    // Flip coordinates from UIKit to Core Graphics
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, .0f, bounds.size.height);
    CGContextScaleCTM(context, scale, scale);
    
    float xpos = bounds.size.width *scale;
    float ypos = [[smoothBandpassItems objectAtIndex:0]floatValue];
    CGContextMoveToPoint(context, xpos, ypos);
    for (int i = 1; i < smoothBandpassItems.count; i++) {
        xpos -= 5;
        float ypos = [[smoothBandpassItems objectAtIndex:i] floatValue];
        CGContextAddLineToPoint(context, xpos, bounds.size.height/2 + ypos *bounds.size.height / 2);
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UI
- (void)showHeartRate
{
    //
    UIView *upBackView = [[UIView alloc]initWithFrame:CGRectMake(0,64 , SCREENWIDTH, 136)];
    upBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:upBackView];
    
    UIImageView *heartImagView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 120, 120)];
    heartImagView.contentMode = UIViewContentModeScaleAspectFill;
    heartImagView.layer.contents = (id)[UIImage imageNamed:@"heart"].CGImage;
    [upBackView addSubview:heartImagView];
    
    _rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(heartImagView.right + 5, heartImagView.y +10, SCREENWIDTH - 10 - heartImagView.right, 50)];
    _rateLabel.textColor = [UIColor blueColor];
    _rateLabel.backgroundColor = [UIColor orangeColor];
    [upBackView addSubview:_rateLabel];
    
   _showView = [[UIView alloc]initWithFrame:CGRectMake(0,64 , SCREENWIDTH, SCREENHEIGHT - 64)];
    
    [self.view addSubview:_showView];
}

@end
