<?php
declare (strict_types=1);

namespace app\controller;

use app\BaseController;
use app\model\Item;
use app\model\User;
use Ramsey\Uuid\Uuid;
use think\facade\Db;
use think\Request;
use think\Response;
use think\response\Json;
use think\response\View;

class AdminController extends BaseController
{
    public function index(Request $request): View
    {
        $totalPricePaid = (new Item())->where('paid', 1)->sum('amount');
        $totalPriceUnpaid = (new Item())->where('paid', 0)->sum('amount');
        $totalPrice = $totalPricePaid + $totalPriceUnpaid;
        return view('/admin/index', ['totalPrice' => $totalPrice, 'totalPricePaid' => $totalPricePaid, 'totalPriceUnpaid' => $totalPriceUnpaid]);
    }


    public function user(Request $request): View
    {
        $users = (new User())->field('id,username,is_admin')->select();
        return view('/admin/user', ['users' => $users]);
    }

    /**
     * 修改用户密码
     */
    public function changePassword(Request $request): Json
    {
        $data = $request->param();
        $userId = $data['user_id'] ?? null;
        $newPassword = $data['new_password'] ?? null;
        
        if (!$userId || !$newPassword) {
            return json(['ret' => 0, 'msg' => '参数不完整']);
        }
        
        // 验证密码长度
        if (strlen($newPassword) < 6) {
            return json(['ret' => 0, 'msg' => '密码长度至少6位']);
        }
        
        try {
            $user = User::find($userId);
            if (!$user) {
                return json(['ret' => 0, 'msg' => '用户不存在']);
            }
            
            // 更新密码
            $user->password = password_hash($newPassword, PASSWORD_ARGON2ID);
            $user->save();
            
            return json(['ret' => 1, 'msg' => '密码修改成功']);
        } catch (\Exception $e) {
            return json(['ret' => 0, 'msg' => '密码修改失败：' . $e->getMessage()]);
        }
    }

    /**
     * 切换用户管理员权限
     */
    public function toggleAdmin(Request $request): Json
    {
        $data = $request->param();
        $userId = $data['user_id'] ?? null;
        $setAsAdmin = $data['set_as_admin'] ?? null;
        
        if ($userId === null || $setAsAdmin === null) {
            return json(['ret' => 0, 'msg' => '参数不完整']);
        }
        
        try {
            $user = User::find($userId);
            if (!$user) {
                return json(['ret' => 0, 'msg' => '用户不存在']);
            }
            
            // 检查是否为当前登录的管理员
            $currentUser = User::find(session('userid'));
            if ($currentUser && $currentUser->id == $userId) {
                return json(['ret' => 0, 'msg' => '不能修改自己的管理员权限']);
            }
            
            // 更新管理员权限
            $user->is_admin = (bool)$setAsAdmin;
            $user->save();
            
            $action = $setAsAdmin ? '设为管理员' : '取消管理员权限';
            return json(['ret' => 1, 'msg' => "用户权限已更新：{$action}"]);
        } catch (\Exception $e) {
            return json(['ret' => 0, 'msg' => '权限更新失败：' . $e->getMessage()]);
        }
    }

    public function itemList(Request $request): View
    {
        $user_id = $request->param('userid');
        if ($user_id === null) {
            $items = Db::table('item')
                ->join('user', 'item.userid = user.id')
                ->order('item.id', 'desc')
                ->field('item.id,user.username,item.description,item.amount,item.paid,item.created_at')
                ->select();
        } else {
            $items = Db::table('item')
                ->join('user', 'item.userid = user.id')
                ->order('item.id', 'desc')
                ->field('item.id,user.username,item.description,item.amount,item.paid,item.created_at')
                ->where('userid', $user_id)->select();
        }
        return view('/admin/item', ['items' => $items]);
    }

    public function itemDelete(Request $request, string $id): Json
    {
        $item = (new Item())->where('id', (int) $id)->findOrEmpty();
        if ($item->isEmpty()) {
            return json(['ret' => 0, 'msg' => '未找到该项目']);
        }
        $item->delete();
        return json(['ret' => 1, 'msg' => '删除成功'])->header(['HX-Refresh' => 'true']);
    }

    public function updateItemStatus(Request $request): Json
    {
        $item = (new Item())->where('id', $request->param('id'))->findOrEmpty();
        if ($item->isEmpty()) {
            return json(['ret' => 0, 'msg' => 'Item not found'])->header(['HX-Refresh' => 'true']);
        }
        $item->paid = $request->param('paid');
        $item->save();
        return json(['ret' => 1, 'msg' => '更新成功'])->header(['HX-Refresh' => 'true']);
    }

    public function bestPay(Request $request): View
    {
        $bestPay = $this->app->userService->getBestPay();
        $userStat = $this->app->userService->getUserStat();
        return view('/admin/bestpay', ['bestPayAll' => $bestPay[1], 'bestPayFinal' => $bestPay[0], 'userStat' => $userStat]);
    }

    /**
     * 下载最优支付方案
     */
    public function downloadBestPay(Request $request): Response
    {
        // 获取最优支付方案和用户统计
        $bestPay = $this->app->userService->getBestPay();
        $userStat = $this->app->userService->getUserStat();
        $data = [
            'bestPayFinal' => $bestPay[0],
            'userStat' => $userStat
        ];
        $json = json_encode($data, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
        $filename = 'bestpay_' . date('Ymd_His') . '.json';
        header('Content-Type: application/json');
        header('Content-Disposition: attachment; filename="' . $filename . '"');
        header('Pragma: no-cache');
        header('Expires: 0');
        return response($json);
    }

    /**
     * 清空所有待支付记录
     */
    public function clearBestPay(Request $request): Json
    {
        Db::table('item')->delete(true);
        return json(['ret' => 1, 'msg' => "已清空数据库"])->header(['HX-Refresh' => 'true']);
    }

    public function settings(): View
    {
        $settings = app()->settingService->getAllSettings();
        $settingData = [];
        $categories = [];

        foreach ($settings as $category => $items) {
            $categories[] = $category;
            foreach ($items as $item) {
                $key = $item['key'];
                $settingData[$key] = app()->settingService->getSetting($key);
            }
        }
        return view('/admin/setting/index', [
            'settings' => $settings,
            'settingData' => $settingData,
            'categories' => $categories,
        ]);
    }

    public function updateSetting(Request $request): Json
    {
        $data = $request->param();
        foreach ($data as $key => $value) {
            app()->settingService->updateSetting($key, $value);
        }
        return json(['ret' => 1, 'msg' => "设置已更新"]);
    }
}
