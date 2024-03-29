//
//  YJNetManager.m
//  YJNetManagerDemo
//
//  Created by 刘亚军 on 2019/3/16.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJNetManager.h"
#import <AFNetworking/AFNetworking.h>

#import <YJExtensions/YJExtensions.h>
#import "YJNetMonitoring.h"

@interface YJNetManager ()
@property (nonatomic,copy) NSString *wUrl;
@property (nonatomic,assign) YJRequestType wRequestType;
@property (nonatomic,assign) YJResponseType wResponseType;
@property (nonatomic,copy) NSDictionary *wParameters;
@property (nonatomic,copy) NSDictionary *wHttpHeader;
@property (nonatomic,strong) YJUploadModel *wUploadModel;
@property (nonatomic,assign) NSTimeInterval wTimeout;

@property (nonatomic,strong) NSURLSessionDataTask *currentDataTask;
@end

@implementation YJNetManager
+ (YJNetManager *)defaultManager{
    static YJNetManager * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[YJNetManager alloc]init];
        [macro replace];
    });
    return macro;
}

#pragma mark - Private
- (void)replace {
    _wUrl = nil;
    _wRequestType = YJRequestTypeGET;
    _wResponseType = YJResponseTypeJSON;
    _wParameters = nil;
    _wHttpHeader = nil;
    _wUploadModel = nil;
    _wTimeout = 15;
}
- (void)cancelRequest{
    if (self.currentDataTask) {
        [self.currentDataTask cancel];
    }
}
- (NSString *)currentServiceTimeStamp{
    NSTimeInterval currentDateInterval = [self.currentServiceTimeString.yj_date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.f",currentDateInterval*1000];
}
- (NSString *)currentServiceTimeString{
    NSDate *currentServiceDate = [[NSDate date] dateByAddingTimeInterval:self.serverTimeInteverval];
    NSString *currentServiceStr = currentServiceDate.yj_string;
    return currentServiceStr;
}
- (void)getRequestWithSuccess:(void(^)(id response))success failure:(void (^)(NSError * error))failure{
    NSString *urlStr = [self.wUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (self.wParameters) {
        urlStr = [NSString stringWithFormat:@"%@?%@",urlStr,[self.wParameters yj_URLQueryString]];
    }
    NSURL *requestUrl = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    request.timeoutInterval = self.wTimeout;
    NSURLSession *session = [NSURLSession sharedSession];
    YJResponseType responseType = self.wResponseType;
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failure(error);
            }else{
                success([weakSelf responseResultWithData:data responseType:responseType]);
            }
        });
    }];
    [dataTask resume];
    self.currentDataTask = dataTask;
}
- (void)postRequestWithSuccess:(void(^)(id response))success failure:(void (^)(NSError * error))failure{
    NSString *urlStr = [self.wUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *requestUrl = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = self.wTimeout;
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:self.wParameters options:NSJSONWritingPrettyPrinted error:NULL];
    NSURLSession *session = [NSURLSession sharedSession];
    YJResponseType responseType = self.wResponseType;
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failure(error);
            }else{
                success([weakSelf responseResultWithData:data responseType:responseType]);
            }
        });
    }];
    [dataTask resume];
    self.currentDataTask = dataTask;
}
- (void)txtRequestWithSuccess:(void(^)(id response))success failure:(void (^)(NSError * error))failure{
    if (![NSFileManager yj_fileIsExistOfPath:self.wUrl]) {
        failure([NSError yj_errorWithCode:YJErrorUrlEmpty description:@"资源不存在"]);
        return;
    }
    NSString *urlStr = self.wUrl;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *str = [[NSString alloc] initWithContentsOfFile:urlStr encoding:NSUTF8StringEncoding error:nil];
        NSData *JSONData = [str dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (JSONData) {
                NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
                if (responseJSON && responseJSON.count > 0) {
                    success(responseJSON);
                }else{
                    failure([NSError yj_errorWithCode:YJErrorUrlEmpty description:@"资源不存在"]);
                }
            }else{
                failure([NSError yj_errorWithCode:YJErrorUrlEmpty description:@"资源不存在"]);
            }
        });
    });
}
- (void)uploadGetRequestWithProgress:(nullable void(^)(NSProgress * progress))progress success:(void(^)(id response))success failure:(void (^)(NSError * error))failure{
     NSString *urlStr = [self.wUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    __weak typeof(self) weakSelf = self;
    [manager POST:urlStr parameters:self.wParameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < weakSelf.wUploadModel.uploadDatas.count; i++) {
            NSData *imageData = weakSelf.wUploadModel.uploadDatas[i];
            NSString *imageName = weakSelf.wUploadModel.fileNames[i];
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"%@%i",weakSelf.wUploadModel.name,i] fileName:imageName mimeType:weakSelf.wUploadModel.fileType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progress(uploadProgress);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            success(responseObject);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}
- (void)md5GetRequestWithSuccess:(void(^)(id response))success failure:(void (^)(NSError * error))failure{
    YJResponseType responseType = self.wResponseType;
  
    NSMutableURLRequest *request = [self exerciseMd5GetReqWithUrl:self.wUrl];
     request.timeoutInterval = self.wTimeout;
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failure(error);
            }else{
                success([weakSelf responseResultWithData:data responseType:responseType]);
            }
        });
    }];
    [dataTask resume];
    self.currentDataTask = dataTask;
}
- (void)md5PostRequestWithSuccess:(void(^)(id response))success failure:(void (^)(NSError * error))failure{
    YJResponseType responseType = self.wResponseType;
   
    NSMutableURLRequest *request = [self exerciseMd5PostReqWithUrl:self.wUrl];
    request.timeoutInterval = self.wTimeout;
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failure(error);
            }else{
                success([weakSelf responseResultWithData:data responseType:responseType]);
            }
        });
    }];
    [dataTask resume];
    self.currentDataTask = dataTask;
}
- (id)responseResultWithData:(NSData *)data responseType:(YJResponseType)type{
    switch (type) {
        case YJResponseTypeJSON:
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            return json;
        }
            break;
        case YJResponseTypeString:
        {
            NSData *xmldata = [data subdataWithRange:NSMakeRange(0,40)];
            NSString *xmlstr = [[NSString alloc] initWithData:xmldata encoding:NSUTF8StringEncoding];
            NSData *newData = data;
            if (xmlstr && xmlstr.length > 0 && [xmlstr rangeOfString:@"\"GB2312\"" options:NSCaseInsensitiveSearch].location != NSNotFound){
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                NSString *utf8str = [[NSString alloc] initWithData:newData encoding:enc];
                utf8str = [utf8str stringByReplacingOccurrencesOfString:@"\"GB2312\"" withString:@"\"utf-8\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,40)];
                newData = [utf8str dataUsingEncoding:NSUTF8StringEncoding];
            }
            NSString *str = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
            if (!str || str.length == 0) {
                str = [[NSString alloc] initWithData:newData encoding:NSUnicodeStringEncoding];
            }
            return str;
        }
            break;
        case YJResponseTypeData:
            return data;
            break;
    }
}
#pragma mark - Public
- (void)startRequestWithSuccess:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure{
    [self startRequestWithProgress:nil success:success failure:failure];
}
- (void)startRequestWithProgress:(void (^)(NSProgress * _Nonnull))progress success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure{
    if ([YJNetMonitoring shareMonitoring].netStatus > 0 || self.wRequestType == YJRequestTypeTxt) {
        if (self.wUrl && self.wUrl.length > 0) {
            [self _startRequestWithProgress:progress success:success failure:failure];
        }else{
            failure([NSError yj_errorWithCode:YJErrorUrlEmpty description:@"url empty"]);
        }
    }else{
        failure([NSError yj_errorWithCode:YJErrorNoNetwork description:@"无网络连接"]);
    }
}
- (void)_startRequestWithProgress:(void(^)(NSProgress * progress))progress success:(void(^)(id response))success failure:(void (^)(NSError * error))failure{
    switch (self.wRequestType) {
        case YJRequestTypeGET:
            [self getRequestWithSuccess:success failure:failure];
            break;
        case YJRequestTypePOST:
            [self postRequestWithSuccess:success failure:failure];
            break;
        case YJRequestTypeTxt:
            [self txtRequestWithSuccess:success failure:failure];
            break;
        case YJRequestTypeUpload:
            [self uploadGetRequestWithProgress:progress success:success failure:failure];
            break;
        case YJRequestTypeMD5GET:
            [self md5GetRequestWithSuccess:success failure:failure];
            break;
        case YJRequestTypeMD5POST:
            [self md5PostRequestWithSuccess:success failure:failure];
            break;
        default:
            break;
    }
    [self replace];
}

- (void)downloadCacheFileWithSuccess:(void (^)(id _Nullable))success failure:(void (^)(NSError * _Nullable))failure{
    NSString *fileName = [self.wUrl componentsSeparatedByString:@"/"].lastObject;
    NSString *urlString = [self.wUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *path = [[self cachePath] stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        success(path);
        return;
    };
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = self.wTimeout;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *path = [[weakSelf cachePath] stringByAppendingPathComponent:fileName];
        //这里返回的是文件下载到哪里的路径 要注意的是必须是携带协议file://
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure([NSError yj_errorWithCode:YJErrorRequestFailed description:@"缓存失败"]);
            }
        }else {
            NSString *path = [filePath path];
            if (success) {
                success(path);
            }
        }
    }];
    [task resume];
    [self replace];
}

#pragma mark - Setter && Getter
- (NSMutableURLRequest *)exerciseMd5GetReqWithUrl:(NSString *)url{
    NSString *urlStr = url;
    NSString *dataStr = @"";
    if (self.wParameters) {
        dataStr = [NSString yj_encryptWithKey:self.userID encryptStr:[self.wParameters yj_URLQueryString]];
    }
    urlStr = [NSString stringWithFormat:@"%@?%@",urlStr,dataStr];
    NSURL *requestUrl = [NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    request.allHTTPHeaderFields = [self exerciseMd5ParamsWithMd5Str:dataStr];
    return request;
}
- (NSMutableURLRequest *)exerciseMd5PostReqWithUrl:(NSString *)url{
    NSURL *requestUrl = [NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    NSString *dataStr = @"";
    if (self.wParameters) {
        dataStr = [NSString yj_encryptWithKey:self.userID encryptDic:self.wParameters];
    }
    request.HTTPBody = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    request.allHTTPHeaderFields = [self exerciseMd5ParamsWithMd5Str:dataStr];
    return request;
}
- (NSDictionary *)exerciseMd5ParamsWithMd5Str:(NSString *)md5Str{
    NSString *md5String = [NSString stringWithFormat:@"%@%@%@",self.userID,self.currentServiceTimeStamp,md5Str];
    NSString *sign = [NSString yj_md5EncryptStr:md5String];
    NSString *secret = [[NSString yj_md5EncryptStr:[NSString stringWithFormat:@"%@%@%@",[[NSString yj_md5EncryptStr:@"LanCooKeyLanCooSecret"] uppercaseString],self.userID,@"addtionSecret"]] uppercaseString];
    NSDictionary *md5Params = @{
                                    @"secret": secret,
                                    @"context":@"CONTEXT04",
                                    @"platform":self.userID,
                                    @"timestamp":self.currentServiceTimeStamp,
                                    @"sign":sign
                                    };
    return md5Params;
}
- (NSString *)cachePath{
    NSString *filePath = [NSString stringWithFormat:@"%@/Library/YJCache/",NSHomeDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}
- (YJNetManager * _Nonnull (^)(NSString * _Nonnull))setRequest{
    return ^YJNetManager* (NSString *url) {
        self.wUrl = url;
        return self;
    };
}
- (YJNetManager * _Nonnull (^)(NSTimeInterval))setTimeoutInterval{
    return ^YJNetManager *(NSTimeInterval timeoutInterval){
        self.wTimeout = timeoutInterval;
        return self;
    };
}

- (YJNetManager * _Nonnull (^)(YJRequestType))setRequestType{
    return ^YJNetManager* (YJRequestType requestType) {
        self.wRequestType = requestType;
        return self;
    };

}
- (YJNetManager * _Nonnull (^)(YJResponseType))setResponseType{
    return ^YJNetManager* (YJResponseType responseType) {
        self.wResponseType = responseType;
        return self;
    };
}
- (YJNetManager * _Nonnull (^)(NSDictionary * _Nonnull))setParameters{
    return ^YJNetManager* (NSDictionary *parameters) {
        self.wParameters = parameters;
        return self;
    };
}
- (YJNetManager * _Nonnull (^)(NSDictionary * _Nonnull))setHTTPHeader{
    return ^YJNetManager* (NSDictionary *HTTPHeaderDic) {
        self.wHttpHeader = HTTPHeaderDic;
        return self;
    };
}
- (YJNetManager * _Nonnull (^)(YJUploadModel * _Nonnull))setUploadModel{
    return ^YJNetManager * (YJUploadModel *uploadModel) {
        self.wUploadModel = uploadModel;
        return self;
    };
}
@end


