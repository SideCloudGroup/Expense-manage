<?php
declare (strict_types=1);

namespace app\service;

use app\model\Currency;
use Exception;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\GuzzleException;
use think\facade\Cache;
use think\Service;

class CurrencyService extends Service
{
    private string $apiUrl = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/{type}.json";

    public function register(): void
    {
        $this->app->bind('currencyService', CurrencyService::class);
    }

    public function getDefaultCurrency(): string
    {
        return $this->getCurrencyList()[0];
    }

    public function getCurrencyList(): array
    {
        return explode(',', env('CURRENCY_LIST'));
    }

    public function getExchangeRate(): array
    {
        $exchangeRate = Cache::get('exchangeRate');
        if ($exchangeRate === null) {
            $exchangeRate = $this->fetchExchangeRate();
        } else {
            return $exchangeRate;
        }
        Cache::set('exchangeRate', $exchangeRate, 3600);
        return $exchangeRate;
    }

    /**
     * @throws GuzzleException
     * @throws Exception
     */
    public function fetchExchangeRate(): array
    {
        $exchangeRate = [];
        $currencyList = $this->getCurrencyList();
        $base = $currencyList[0];
        $exchangeRate[$base] = 1;
        if (sizeof($currencyList) == 1) {
            return $exchangeRate;
        }
        $client = new Client();
        $res = $client->request('GET', str_replace('{type}', $base, $this->apiUrl), [
            'timeout' => 15,
            'headers' => [
                'Accept' => 'application/json',
            ],
        ]);
        if ($res->getStatusCode() != "200") {
            throw new Exception("Failed to fetch exchange rate");
        }
        $data = json_decode((string) $res->getBody(), true);
        if (! isset($data[$base])) {
            throw new Exception("Invalid exchange rate data. " . $base . " not found");
        }
        foreach ($currencyList as $currency) {
            if ($currency == $base) continue;
            if (! isset($data[$base][$currency])) {
                throw new Exception("Invalid exchange rate data. " . $currency . " not found");
            }
            $exchangeRate[$currency] = round($data[$base][$currency], 4);
        }
        return $exchangeRate;
    }

    /**
     * 获取派对特定的汇率
     */
    public function getPartyExchangeRate(string $baseCurrency, array $supportedCurrencies = []): array
    {
        $cacheKey = "party_exchange_rate_{$baseCurrency}_" . md5(serialize($supportedCurrencies));
        $exchangeRate = Cache::get($cacheKey);

        if ($exchangeRate === null) {
            $exchangeRate = $this->fetchPartyExchangeRate($baseCurrency, $supportedCurrencies);
            Cache::set($cacheKey, $exchangeRate, 3600);
        }

        return $exchangeRate;
    }

    /**
     * 获取派对特定汇率
     * @throws GuzzleException
     * @throws Exception
     */
    private function fetchPartyExchangeRate(string $baseCurrency, array $supportedCurrencies = []): array
    {
        $exchangeRate = [];
        $exchangeRate[$baseCurrency] = 1;

        if (empty($supportedCurrencies)) {
            return $exchangeRate;
        }

        $client = new Client();
        $res = $client->request('GET', str_replace('{type}', $baseCurrency, $this->apiUrl), [
            'timeout' => 15,
            'headers' => [
                'Accept' => 'application/json',
            ],
        ]);

        if ($res->getStatusCode() != "200") {
            throw new Exception("Failed to fetch exchange rate");
        }

        $data = json_decode((string) $res->getBody(), true);
        if (! isset($data[$baseCurrency])) {
            throw new Exception("Invalid exchange rate data. " . $baseCurrency . " not found");
        }

        foreach ($supportedCurrencies as $currency) {
            if ($currency == $baseCurrency) continue;
            if (! isset($data[$baseCurrency][$currency])) {
                // 如果API中没有该货币的汇率，跳过
                continue;
            }
            $exchangeRate[$currency] = round($data[$baseCurrency][$currency], 4);
        }

        return $exchangeRate;
    }

    /**
     * 验证货币代码是否有效
     */
    public function isValidCurrency(string $currencyCode): bool
    {
        try {
            return Currency::codeExists($currencyCode);
        } catch (Exception $e) {
            error_log('Failed to validate currency: ' . $e->getMessage());
            return false;
        }
    }

    /**
     * 获取货币信息
     */
    public function getCurrencyInfo(string $currencyCode): ?array
    {
        try {
            $currency = Currency::getByCode($currencyCode);
            if (! $currency) {
                return null;
            }

            return [
                'id' => $currency->id,
                'name' => $currency->name,
                'name_en' => $currency->name_en,
                'symbol' => $currency->symbol,
                'code' => strtoupper($currency->code),
                'decimal_places' => $currency->decimal_places,
                'is_default' => $currency->is_default,
                'is_active' => $currency->is_active
            ];
        } catch (Exception $e) {
            error_log('Failed to get currency info: ' . $e->getMessage());
            return null;
        }
    }

    /**
     * 获取货币名称（支持多语言）
     */
    public function getCurrencyName(string $currencyCode, string $language = 'zh'): string
    {
        try {
            $currency = Currency::getByCode($currencyCode);
            if (! $currency) {
                return strtoupper($currencyCode);
            }

            if ($language === 'en' && ! empty($currency->name_en)) {
                return $currency->name_en;
            }

            return $currency->name;
        } catch (Exception $e) {
            error_log('Failed to get currency name: ' . $e->getMessage());
            return strtoupper($currencyCode);
        }
    }

    /**
     * 获取货币显示名称
     */
    public function getCurrencyDisplayName(string $currencyCode): string
    {
        $currencies = $this->getAllAvailableCurrencies();
        return $currencies[$currencyCode]['name'] ?? strtoupper($currencyCode);
    }

    /**
     * 获取所有可用货币列表
     */
    public function getAllAvailableCurrencies(): array
    {
        try {
            $currencies = Currency::getActiveCurrencies();
            $result = [];

            foreach ($currencies as $currency) {
                $result[$currency->code] = [
                    'id' => $currency->id,
                    'name' => $currency->name,
                    'name_en' => $currency->name_en,
                    'symbol' => $currency->symbol,
                    'code' => strtoupper($currency->code),
                    'decimal_places' => $currency->decimal_places,
                    'is_default' => $currency->is_default,
                    'is_active' => $currency->is_active
                ];
            }

            return $result;
        } catch (Exception $e) {
            // 如果数据库读取失败，返回默认货币列表
            error_log('Failed to load currencies from database: ' . $e->getMessage());
            return $this->getDefaultCurrencies();
        }
    }

    /**
     * 获取默认货币列表（作为备用）
     */
    private function getDefaultCurrencies(): array
    {
        return [
            'cny' => [
                'id' => 1,
                'name' => '人民币',
                'name_en' => 'Chinese Yuan',
                'symbol' => '¥',
                'code' => 'CNY',
                'decimal_places' => 2,
                'is_default' => true,
                'is_active' => true
            ]
        ];
    }

    /**
     * 获取货币符号
     */
    public function getCurrencySymbol(string $currencyCode): string
    {
        $currencies = $this->getAllAvailableCurrencies();
        return $currencies[$currencyCode]['symbol'] ?? strtoupper($currencyCode);
    }
}
