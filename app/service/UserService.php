<?php
declare (strict_types=1);

namespace app\service;

use app\model\Item;
use app\model\User;
use think\facade\Db;
use think\Service;

class UserService extends Service
{
    private User $user;

    public function register()
    {
        $this->app->bind('userService', UserService::class);
    }

    public function getUser(): User|null
    {
        global $user;
        if ($user === null) {
            $user = (new User())->where('id', session('userid'))->findOrEmpty();
        }
        if ($user->isEmpty()) {
            $user = null;
        }
        return $user;
    }

    public function getUserList(): array
    {
        $user = new User();
        return $user->field('id,username')->select()->toArray();
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
        $users = Db::table('user')->field('id, username')->select()->toArray();
        $users = array_column($users, 'username', 'id');
        $userUnpaid = [];
        // 获取所有未支付订单
        $unpaid = (new Item())->where('paid', 0)->field(['userid, amount, initiator'])->select();
        foreach ($unpaid as $item) {
            if (! isset($userUnpaid[$item->userid][$item->initiator])) {
                $userUnpaid[$item->userid][$item->initiator] = 0;
            }
            $userUnpaid[$item->userid][$item->initiator] += $item->amount;
        }
        $tmpResult = [];
        // 抵消付款人和收款人
        foreach ($users as $payer_id => $payer) {
            foreach ($users as $payee_id => $payee) {
                if ($payer_id == $payee_id) {
                    continue;
                }
                if (isset($tmpResult[$payer_id][$payee_id]) || isset($tmpResult[$payee_id][$payer_id])) {
                    continue;
                }
                $diff = ($userUnpaid[$payer_id][$payee_id] ?? 0) - ($userUnpaid[$payee_id][$payer_id] ?? 0);
                match (true) {
                    $diff < 0 => [
                        $tmpResult[$payer_id][$payee_id] = 0,
                        $tmpResult[$payee_id][$payer_id] = -$diff,
                    ],
                    $diff > 0 => [
                        $tmpResult[$payer_id][$payee_id] = $diff,
                        $tmpResult[$payee_id][$payer_id] = 0,
                    ],
                    default => [
                        $tmpResult[$payer_id][$payee_id] = 0,
                        $tmpResult[$payee_id][$payer_id] = 0,
                    ],
                };
            }
        }

        // 使用用户名替换用户ID，并去除0值
        $result = [];
        foreach ($tmpResult as $payer_id => $payer) {
            foreach ($payer as $payee_id => $amount) {
                if ($amount !== 0) {
                    $result[$users[$payer_id]][$users[$payee_id]] = $amount;
                }
            }
        }
        return $result;
    }
}
