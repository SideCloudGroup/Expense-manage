<?php
declare (strict_types=1);

namespace app\validate;

use think\Validate;

class Item extends Validate
{
    /**
     * 定义验证规则
     * 格式：'字段名' =>  ['规则1','规则2'...]
     *
     * @var array
     */
    protected $rule = [
        'description' => 'require',
        'amount' => 'require|float',
        'users' => 'require|array',
    ];

    protected $message = [
        'description.require' => '描述不能为空',
        'amount.require' => '金额不能为空',
        'amount.float' => '金额必须为数字',
        'users.require' => '用户不能为空',
        'users.array' => '用户必须为数组',
    ];
}
