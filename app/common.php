<?php
// 应用公共文件

use app\model\Currency;
use app\model\Party;

function getSetting(string $key, $default = null)
{
    return app()->settingService->getSetting($key, $default);
}

function formatTimezone(string $timezone): string
{
    // 尝试验证时区是否有效
    try {
        $dateTimeZone = new DateTimeZone($timezone);
        // 获取当前时区的偏移量（自动处理夏令时）
        $dateTime = new DateTime('now', $dateTimeZone);
        $offset = $dateTime->format('P');
        return $timezone . ' (' . $offset . ')';
    } catch (Exception $e) {
        // 如果时区无效，返回原始值
        return $timezone;
    }
}
