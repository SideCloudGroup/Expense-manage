<?php
declare (strict_types=1);

namespace app\service;

use app\model\Item;
use app\model\User;
use think\facade\Db;
use think\Service;

class UserService extends Service
{
    public function register()
    {
        $this->app->bind('userService', UserService::class);
    }

    public function getUserList(): array
    {
        $user = new User();
        return $user->field('id,name')->select()->toArray();
    }

    public function getUserDetails(int $id): array
    {
        $user = (new User())->where('id', $id)->findOrEmpty();
        if ($user === null) {
            return ['ret' => 0, 'msg' => 'User not found'];
        }
        $userDetails = (new Item())->where('userid', $id)->select()->toArray();
        $totalPrice = 0.0;
        foreach ($userDetails as $item) {
            $totalPrice += $item['amount'];
        }
        return ['ret' => 1, 'data' => $userDetails, 'totalPrice' => $totalPrice];
    }

    public function getBestPay(): array
    {
        $users = Db::table('user')->field('id, username')->select();
        $userUnpaidAmounts = [];
        $result = [];
        foreach ($users as $user) {
            $userUnpaidAmounts[$user['id']] = (new Item())->where('userid', $user['id'])->where('paid', 0)->sum('amount');
        }
        foreach ($users as $user1) {
            foreach ($users as $user2) {
                if ($user1['id'] >= $user2['id']) {
                    continue;
                }
                $totalPrice1 = $userUnpaidAmounts[$user1['id']];
                $totalPrice2 = $userUnpaidAmounts[$user2['id']];
                if ($totalPrice1 - $totalPrice2 == 0) {
                    continue;
                }
                if ($totalPrice1 > $totalPrice2) {
                    $result[$user2['username']][$user1['username']] = $totalPrice1 - $totalPrice2;
                } else {
                    $result[$user1['username']][$user2['username']] = $totalPrice2 - $totalPrice1;
                }
            }
        }
        $time_end = microtime(true);
        return $result;
    }
}
