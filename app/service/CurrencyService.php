<?php
declare (strict_types=1);

namespace app\service;

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
        return explode(',', env('CURRENCY.LIST'));
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
        $data = json_decode((string)$res->getBody(), true);
        if (!isset($data[$base])) {
            throw new Exception("Invalid exchange rate data. " . $base . " not found");
        }
        foreach ($currencyList as $currency) {
            if ($currency == $base) continue;
            if (!isset($data[$base][$currency])) {
                throw new Exception("Invalid exchange rate data. " . $currency . " not found");
            }
            $exchangeRate[$currency] = round($data[$base][$currency], 4);
        }
        return $exchangeRate;
    }
}
