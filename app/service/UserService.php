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
        return $user->where('enable', true)->field('id,username')->order('username', 'asc')->select()->toArray();
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

    public function addItem(int $userID, string $description, float $amount, int $initiator): bool
    {
        $item = new Item();
        $item->userid = $userID;
        $item->description = $description;
        $item->amount = $amount;
        $item->paid = $userID === $initiator;
        $item->created_at = date('Y-m-d H:i:s');
        $item->initiator = $initiator;
        return $item->save();
    }

    public function getUserStat(): array
    {
        $users = Db::table('user')->field('id, username')->select()->toArray();
        $users = array_column($users, 'username', 'id');
        $userStat = [];
        foreach ($users as $id => $username) {
            $userStat[$username]['in'] = (new Item())->where('initiator', $id)->where('paid', 0)->sum('amount');
            $userStat[$username]['out'] = (new Item())->where('userid', $id)->where('paid', 0)->sum('amount');
        }
        return $userStat;
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
        $stage1 = $result;
        // 进一步优化
        $debtsDict = $result;
        $balance = [];

        // 计算每个人的净余额
        foreach ($debtsDict as $debtor => $creditors) {
            foreach ($creditors as $creditor => $amount) {
                if (! isset($balance[$debtor])) {
                    $balance[$debtor] = 0;
                }
                if (! isset($balance[$creditor])) {
                    $balance[$creditor] = 0;
                }
                $balance[$debtor] -= $amount;
                $balance[$creditor] += $amount;
            }
        }

        // 分离出正负余额
        $creditors = [];
        $debtors = [];
        foreach ($balance as $person => $bal) {
            if ($bal > 0) {
                $creditors[] = [$person, $bal];
            } elseif ($bal < 0) {
                $debtors[] = [$person, -$bal];
            }
        }

        // 优化支付方案
        $optimizedDebts = [];
        $i = 0;
        $j = 0;
        while ($i < count($creditors) && $j < count($debtors)) {
            list($creditor, $credAmount) = $creditors[$i];
            list($debtor, $debtAmount) = $debtors[$j];

            if ($credAmount > $debtAmount) {
                $optimizedDebts[] = [$debtor, $creditor, $debtAmount];
                $creditors[$i][1] -= $debtAmount;
                $j++;
            } elseif ($credAmount < $debtAmount) {
                $optimizedDebts[] = [$debtor, $creditor, $credAmount];
                $debtors[$j][1] -= $credAmount;
                $i++;
            } else {
                $optimizedDebts[] = [$debtor, $creditor, $credAmount];
                $i++;
                $j++;
            }
        }

        // 转换为字典形式
        $optimizedDict = [];
        foreach ($optimizedDebts as $debt) {
            list($debtor, $creditor, $amount) = $debt;
            if (! isset($optimizedDict[$debtor])) {
                $optimizedDict[$debtor] = [];
            }
            $optimizedDict[$debtor][$creditor] = round($amount, 2);
        }

        return [$optimizedDict, $stage1];
    }

    public function updateUserProfile(int $id, string $username, string $password): array
    {
        $user = (new User())->where('id', $id)->findOrEmpty();
        if ($user->isEmpty()) {
            return array('ret' => 0, 'msg' => '未找到该用户');
        }
        # 检查用户名是否重复
        if ($user->username != $username) {
            # 检查用户名是否重复
            $user_tmp = (new User())->where('username', $username)->findOrEmpty();
            if (! $user_tmp->isEmpty()) {
                return array('ret' => 0, 'msg' => '用户名已存在');
            }
            $user->username = $username;
        }
        # 更新密码
        if ($password != '') {
            $user->password = password_hash($password, PASSWORD_ARGON2ID);
        }
        $user->save();
        return array('ret' => 1, 'msg' => '更新成功');
    }
}
