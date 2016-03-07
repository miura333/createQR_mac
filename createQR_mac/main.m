//
//  main.m
//  createQR_mac
//
//  Created by miura on 2015/08/14.
//  Copyright (c) 2015年 arara. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Quartz;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        CIFilter *ciFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [ciFilter setDefaults];
        
        // 格納する文字列をNSData形式（UTF-8でエンコード）で用意して設定
        const char *hoge = argv[1];
        NSString *fuga = [NSString stringWithUTF8String:hoge];
        
        NSLog(@"fuga = %@", fuga);
        
        NSData *data = [fuga dataUsingEncoding:NSUTF8StringEncoding];
        [ciFilter setValue:data forKey:@"inputMessage"];
        [ciFilter setValue:@"L" forKey:@"inputCorrectionLevel"];
        
        // 画像を256*256に拡大。普通に拡大すると補間かかるのでニアレストネイバー法で
        NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                           pixelsWide:256
                                                                           pixelsHigh:256
                                                                        bitsPerSample:8
                                                                      samplesPerPixel:4
                                                                             hasAlpha:YES
                                                                             isPlanar:NO
                                                                       colorSpaceName:NSDeviceRGBColorSpace
                                                                          bytesPerRow:4 * 256
                                                                         bitsPerPixel:32];
        NSGraphicsContext *g = [NSGraphicsContext graphicsContextWithBitmapImageRep:rep];
        CGContextRef context = [g graphicsPort];
        
        CIContext *ciContext = [CIContext contextWithCGContext:context options:nil];
        CGImageRef img = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];
        
        CGContextSetInterpolationQuality(context, kCGInterpolationNone);
        CGContextDrawImage(context, CGRectMake(0, 0, 256, 256), img);
        CGImageRef output_image = CGBitmapContextCreateImage(context);
        
        //画像保存
        //ああああああ
        NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop/hoge.png"];
        
        NSBitmapImageRep* rep2 = [[NSBitmapImageRep alloc] initWithCGImage:output_image];
        NSData* PNGData = [rep2 representationUsingType:NSPNGFileType properties:nil];
        [PNGData writeToFile:path atomically:NO];
        //関連するアプリ（プレビューなど）で表示
        [[NSWorkspace sharedWorkspace] openFile:path];

    }
    return 0;
}
