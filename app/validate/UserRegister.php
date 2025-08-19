<?php
declare (strict_types=1);

namespace app\validate;

use think\Validate;

class UserRegister extends Validate
{
    protected $rule = [
        'username' => 'require|min:3|alphaDash',
        'password' => 'require|min:3',
        'captcha' => 'require',
    ];

    protected $message = [
        'username.require' => "用户名不能为空",
        'username.min' => "用户名长度不能少于3位",
        'username.alphaDash' => "用户名只能包含字母、数字、下划线和破折号",
        'password.require' => "密码不能为空",
        'password.min' => "密码长度不能少于3位",
        'captcha.require' => "验证码不能为空"
    ];
}
