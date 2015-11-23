//
//  define.h
//  librtss
//
//  Created by Ming Lyu on 4/1/15.
//  Copyright (c) 2015 Ming Lyu. All rights reserved.
//

#ifndef librtss_define_h
#define librtss_define_h

#define __ENCRYPTION_ENABLED__ NO

//	50000	通用失败
//	50001	查询结果为空
//	50067	获取用户信息失败
//	51001	创建交易号失败
//	51002	获取付费地址失败
//	55001	登录失败
//	55004	登录失败，无法获取AccountId或customerId
//	55005	密码变更（重置）失败
//	55011	登录(VerifySession)失败
//	50066	用户名已被使用
#define __ISTATUS_USERID_OCCUPIED__ 50066
//	57005	查询使用量(queryUsage)失败
#define __ISTATUS_USAGE_NODATA__ 57005
//
//	50009	用户已激活
#define __ISTATUS_USER_REACTIVATE__ 50009
//	50100	缺少必填参数或参数不正确
//	50101	字段不存在或权限不足
//	50102	接口暂未实现
//	50103	处理请求的结果与系统不一致
//	50104	输入的属性验证失败
//	50105	身份验证失败
//	50106	ssoToken用于请求无效
#define __ISTATUS_SESSION_INVALID__ 50106
//	50107	无权执行该操作
//
//	50200	账户已锁
//	50201	OTP达到最大尝试次数
//	50202	OTP已发送
//	50203	无效的用户状态：封锁
#define __ISTATUS_USER_LOCKED__ 50203

#endif
