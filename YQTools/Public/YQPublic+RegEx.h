//
//  YQPublic+RegEx.h
//  Tools
//
//  Created by weixb on 16/12/14.
//  Copyright © 2016年 weixb. All rights reserved.
//

#import "YQPublic.h"

@interface YQPublic (RegEx)

/*! 自己写正则传入进行判断*/
+ (BOOL)wxb_validateData:(NSString *)data withRegEx: (NSString *)RegEx;
//邮箱
+ (BOOL)wxb_validateEmail:(NSString *)data;
//手机号码验证
+ (BOOL)wxb_validateMobile:(NSString *)data;
//车牌号验证
+ (BOOL)wxb_validateCarNo:(NSString *)data;
//车型
+ (BOOL)wxb_validateCarType:(NSString *)data;
//用户名
+ (BOOL)wxb_validateUserName:(NSString *)data;
//密码
+ (BOOL)wxb_validatePassword:(NSString *)data;
//昵称
+ (BOOL)wxb_validateNickname:(NSString *)data;
//身份证号
+ (BOOL)wxb_validateIdentityCard: (NSString *)data;
//手机验证码
+ (BOOL)wxb_validateCheckCode: (NSString *)data;
//判断URL是否能够打开
+ (void)wxb_validateUrl:(NSString *)url block:(void(^)(BOOL))block;
@end
/*
 1 . 校验密码强度
 密码的强度必须是包含大小写字母和数字的组合，不能使用特殊字符，长度在8-10之间。
 
 ^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,10}$
 2. 校验中文
 字符串仅能是中文。
 
 ^[\\u4e00-\\u9fa5]{0,}$
 3. 由数字、26个英文字母或下划线组成的字符串
 ^\\w+$
 
 7. 校验金额
 金额校验，精确到2位小数。
 
 ^[0-9]+(.[0-9]{2})?$
 
 13. 提取URL链接
 下面的这个表达式可以筛选出一段文本中的URL。
 
 ^(f|ht){1}(tp|tps):\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- ./?%&=]*)?
 
 15. 提取Color Hex Codes
 有时需要抽取网页中的颜色代码，可以使用下面的表达式。
 
 ^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$
 16. 提取网页图片
 假若你想提取网页中所有图片信息，可以利用下面的表达式。
 
 \\< *[img][^\\\\>]*[src] *= *[\\"\\']{0,1}([^\\"\\'\\ >]*)
 17. 提取页面超链接
 提取html中的超链接。
 
 (<a\\s*(?!.*\\brel=)[^>]*)(href="https?:\\/\\/)((?!(?:(?:www\\.)?'.implode('|(?:www\\.)?', $follow_list).'))[^"]+)"((?!.*\\brel=)[^>]*)(?:[^>]*)>
 18. 查找CSS属性
 通过下面的表达式，可以搜索到相匹配的CSS属性。
 
 ^\\s*[a-zA-Z\\-]+\\s*[:]{1}\\s[a-zA-Z0-9\\s.#]+[;]{1}
 19. 抽取注释
 如果你需要移除HMTL中的注释，可以使用如下的表达式。
 
 <!--(.*?)-->
 20. 匹配HTML标签
 通过下面的表达式可以匹配出HTML中的标签属性。
 
 <\\/?\\w+((\\s+\\w+(\\s*=\\s*(?:".*?"|'.*?'|[\\^'">\\s]+))?)+\\s*|\\s*)\\/?>
 */
