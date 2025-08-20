<?php
// 应用公共文件

function getSetting(string $key, $default = null)
{
    return app()->settingService->getSetting($key, $default);
}

function formatTimezone(string $timezone): string
{
    // 尝试验证时区是否有效
    try {
        $dateTimeZone = new DateTimeZone($timezone);
        return $timezone;
    } catch (Exception $e) {
        return 'Asia/Shanghai'; // 默认时区
    }
}
