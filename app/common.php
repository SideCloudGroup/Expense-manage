<?php
// 应用公共文件

function getUnitSign(): string
{
    return env('CURRENCY_SIGN', '￥');
}
