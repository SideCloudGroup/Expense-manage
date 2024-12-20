<?php

use app\service\CookieService;
use app\service\CurrencyService;
use app\service\MFAService;
use app\service\UserService;

// 系统服务定义文件
// 服务在完成全局初始化之后执行
return [
    UserService::class,
    CookieService::class,
    CurrencyService::class,
];
