SingSoundSDK for CocoaPod 


singsoundSDK 0.6.1 (2020.09.18)

framework:
    新增开始测评参数vadEnable，用来配置在开始测评时是否开启vad功能。

singsoundSDK 0.6.0 (2020.07.27)

framework:
     (1)  新增在测评结果和报错回调时反馈request_id
   （2）修复本地音频测评bug

singsoundSDK 0.5.9 (2020.06.05)

framework:
   (1) 增加中文识别，英文识别枚举题型 
   (2) 增加压缩后音频数据回调 
   (3) 默认开启动态获取测评地址功能
   (4) 增加在线鉴权配置及回调
   
libssound:
   71-2.0.8-20200402144128

singsound 各模块 1.9.6(2020.04.10)
1. 模考手动提交答案
2. webview更新为wkwebview


singsound 各模块 1.9.5.1(2020.02.21)
1. 优化下载

singsound 各模块 1.9.5(2020.02.18)
1. 修复bug
2. 更新资源文件

singsound 各模块 1.9.4(2020.01.06)
1. 修复返回方式


singsound 各模块 1.9.3(2019.12.31)
1. SSModuleConfig 类添加 app_memo 属性


singsound 各模块 1.9.2(2019.12.16)
1. 修复存在bug
2. 竖屏显示

singsound 各模块 1.9.0(2019.12.2)
1. 修复存在bug

singsound 各模块 1.8.9(2019.11.20)
1. 优化了口语考试流程
2. 优化了作业流程

singsoundSDK 0.5.8 (2019.11.11)
1. 变更录音文件存储逻辑，防止出现损坏的录音文件
2. 增加可以配置评测前置静音功能，用于提升测评稳定性
3. 修复已知bug

singsound 各模块 1.8.4(2019.10.15)
1. 练习模考重新设计
2. 作业模考重新开发
3.添加离线上传模考

singsoundSDK 0.5.7 (2019.07.31)
(singsound.framework 更新)
1. 增加 少儿单词，少儿句子，单词纠错题型
2. 对 iOS 9 系统下 初始化速度慢的问题进行优化

singsoundSDK 0.5.6 (2019.05.31)
1. singsound.framework 更新
(1) 提升稳定性
(2) 增加coreType 字段

2. libsound.a 更新
(1) 解决因为openssl 冲突引起的偶现闪退


singsoundSDK 0.5.5 (2019.05.13)
1. singsound.framework 更新
(1) 调整音频权限检测
(2) 通过帐号分配测评地址

2. libsound.a 更新
(1) 增加离线测评的实时反馈功能
(2) 增加在线测评完全异步功能
(3) 增加在线转离线功能
(4) 增加opus压缩功能，可避免speex冲突问题

singsoundSDK 0.5.4 (2019.03.21)

1. 增加可配置协议头字段protocolHeader
2. 增加可配置端口号字段portNumber
3. allowDynamicService 设置为 YES,将开启内部动态获取测评地址,无需ServiceManager类 及相关阿里巴巴三方库


singsoundSDK 0.5.3 (2019.01.25)

1. 增加本地日志上传功能
2. 增加校验离线资源功能
3. 增加参数拓展回调函数
4. 修复部分潜在内存泄漏危险

singsound 各模块 1.7.0(2019.01.03)
1. 修改获取时间的数据类型


singsound 各模块 1.7.0(2019.01.02)
1. 调整考试题干显示
2.支持北京四中

singsound 各模块 1.6.9(2018.12.26)
1. 修复post失败回调
2. 调整考试图片显示


singsoundSDK 0.5.1 (2018.10.26)
1. 添加 英文段落,中文单词,中文句子,中文段落 超时限制
2. 添加测评失败错误日志收集,设置isOutputLog = YES,在本地记录报错日志（日志路径 ~/Documents/SSError
3. 新增接口 (1) 触发开始测评，但不开启录音 （2）传输音频接口
4. 每次测评开始，检查麦克风权限，无权限报错（200111）




singsound 模块集成 0.5.0(2018.10.09)

1. 添加作业补做功能
2. 作业模块添加支付
3. 作业和练习模块支持返回



singsoundSDK 0.4.9 (2018.09.30)

1. 增加测评失败日志收集，isOutputLog 设置为YES，则会在沙盒路径下（~/Documents/SSError）存储测评失败日志，注意清理日志

2. 添加 封装层 英文段落，中文单词，中文句子，中文段落 即将超时限制

3. 新增：开始测评方法（触发开始测评，但不在sdk内部开启录音），传输音频数据方法（使用该方法之前，需要上一个触发开始测评已成功）
