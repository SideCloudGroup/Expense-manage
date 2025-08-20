<?php
declare (strict_types=1);

namespace app\controller;

use app\BaseController;
use app\model\User;
use Exception;
use think\facade\Db;
use think\Request;
use think\response\Json;
use think\response\View;

class AdminController extends BaseController
{
    public function index(Request $request): View
    {
        // 基础统计数据
        $totalPricePaid = Db::table('item')->where('paid', 1)->sum('amount');
        $totalPriceUnpaid = Db::table('item')->where('paid', 0)->sum('amount');
        $totalPrice = $totalPricePaid + $totalPriceUnpaid;

        // 用户统计
        $totalUsers = (new User())->count();
        $adminUsers = (new User())->where('is_admin', 1)->count();
        $regularUsers = $totalUsers - $adminUsers;

        // 项目统计
        $totalItems = Db::table('item')->count();
        $paidItems = Db::table('item')->where('paid', 1)->count();
        $unpaidItems = Db::table('item')->where('paid', 0)->count();

        // 派对统计
        $totalParties = Db::table('party')->count();
        $activeParties = Db::table('party')
            ->join('party_member', 'party.id = party_member.party_id')
            ->group('party.id')
            ->having('COUNT(party_member.user_id) > 1')
            ->count();


        // 用户活跃度统计（最近30天有活动的用户）
        $thirtyDaysAgo = date('Y-m-d H:i:s', strtotime('-30 days'));
        $activeUsers = Db::table('item')
            ->where('created_at', '>=', $thirtyDaysAgo)
            ->group('userid')
            ->count();

        // 平均项目金额
        $avgItemAmount = $totalItems > 0 ? round($totalPrice / $totalItems, 2) : 0;

        // 支付完成率
        $paymentCompletionRate = $totalItems > 0 ? round(($paidItems / $totalItems) * 100, 1) : 0;

        // 用户活跃度百分比
        $userActivityRate = $totalUsers > 0 ? round(($activeUsers / $totalUsers) * 100, 1) : 0;

        // 派对活跃度百分比
        $partyActivityRate = $totalParties > 0 ? round(($activeParties / $totalParties) * 100, 1) : 0;

        return view('/admin/index', [
            'totalPrice' => $totalPrice,
            'totalPricePaid' => $totalPricePaid,
            'totalPriceUnpaid' => $totalPriceUnpaid,
            'totalUsers' => $totalUsers,
            'adminUsers' => $adminUsers,
            'regularUsers' => $regularUsers,
            'totalItems' => $totalItems,
            'paidItems' => $paidItems,
            'unpaidItems' => $unpaidItems,
            'totalParties' => $totalParties,
            'activeParties' => $activeParties,
            'activeUsers' => $activeUsers,
            'avgItemAmount' => $avgItemAmount,
            'paymentCompletionRate' => $paymentCompletionRate,
            'userActivityRate' => $userActivityRate,
            'partyActivityRate' => $partyActivityRate
        ]);
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

        if (! $userId || ! $newPassword) {
            return json(['ret' => 0, 'msg' => '参数不完整']);
        }

        // 验证密码长度
        if (strlen($newPassword) < 6) {
            return json(['ret' => 0, 'msg' => '密码长度至少6位']);
        }

        try {
            $user = User::find($userId);
            if (! $user) {
                return json(['ret' => 0, 'msg' => '用户不存在']);
            }

            // 更新密码
            $user->password = password_hash($newPassword, PASSWORD_ARGON2ID);
            $user->save();

            return json(['ret' => 1, 'msg' => '密码修改成功']);
        } catch (Exception $e) {
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
            if (! $user) {
                return json(['ret' => 0, 'msg' => '用户不存在']);
            }

            // 检查是否为当前登录的管理员
            $currentUser = User::find(session('userid'));
            if ($currentUser && $currentUser->id == $userId) {
                return json(['ret' => 0, 'msg' => '不能修改自己的管理员权限']);
            }

            // 更新管理员权限
            $user->is_admin = (bool) $setAsAdmin;
            $user->save();

            $action = $setAsAdmin ? '设为管理员' : '取消管理员权限';
            return json(['ret' => 1, 'msg' => "用户权限已更新：{$action}"]);
        } catch (Exception $e) {
            return json(['ret' => 0, 'msg' => '权限更新失败：' . $e->getMessage()]);
        }
    }

    /**
     * 派对管理页面
     */
    public function party(Request $request): View
    {
        // 获取所有派对及其统计信息
        $parties = Db::table('party')
            ->field('party.*, COUNT(DISTINCT party_member.user_id) as member_count')
            ->leftJoin('party_member', 'party.id = party_member.party_id')
            ->group('party.id')
            ->order('party.id', 'desc')
            ->select()
            ->toArray();

        // 为每个派对添加支付统计
        foreach ($parties as $key => $party) {
            // 统计该派对的支付情况
            $partyStats = Db::table('item')
                ->where('party_id', $party['id'])
                ->field('COUNT(*) as total_items, SUM(amount) as total_amount, COUNT(CASE WHEN paid = 1 THEN 1 END) as paid_items, SUM(CASE WHEN paid = 1 THEN amount ELSE 0 END) as paid_amount')
                ->find();

            $parties[$key]['total_items'] = $partyStats['total_items'] ? : 0;
            $parties[$key]['total_amount'] = $partyStats['total_amount'] ? : 0;
            $parties[$key]['paid_items'] = $partyStats['paid_items'] ? : 0;
            $parties[$key]['paid_amount'] = $partyStats['paid_amount'] ? : 0;
            $parties[$key]['unpaid_items'] = $partyStats['total_items'] - $partyStats['paid_items'];
            $parties[$key]['unpaid_amount'] = $partyStats['total_amount'] - $partyStats['paid_amount'];

            // 计算支付完成率
            $parties[$key]['payment_completion_rate'] = $partyStats['total_items'] > 0 ?
                round(($partyStats['paid_items'] / $partyStats['total_items']) * 100, 1) : 0;
        }

        return view('/admin/party/list', ['parties' => $parties]);
    }

    /**
     * 获取派对成员列表页面
     */
    public function partyMembers(Request $request): View
    {
        $partyId = $request->param('id');
        if (! $partyId) {
            return view('/error', ['msg' => '参数错误']);
        }

        // 获取派对信息
        $party = Db::table('party')->where('id', $partyId)->find();
        if (! $party) {
            return view('/error', ['msg' => '派对不存在']);
        }

        // 获取成员列表
        $members = Db::table('party_member')
            ->join('user', 'party_member.user_id = user.id')
            ->join('party', 'party_member.party_id = party.id')
            ->where('party_member.party_id', $partyId)
            ->field('user.id, user.username, CASE WHEN party.owner_id = party_member.user_id THEN 1 ELSE 0 END as is_owner, party_member.joined_at')
            ->order('party_member.joined_at', 'asc')
            ->select();

        // 获取派对统计信息
        $partyStats = Db::table('item')
            ->where('party_id', $partyId)
            ->field('COUNT(*) as total_items, SUM(amount) as total_amount, COUNT(CASE WHEN paid = 1 THEN 1 END) as paid_items, SUM(CASE WHEN paid = 1 THEN amount ELSE 0 END) as paid_amount')
            ->find();

        $stats = [
            'total_items' => $partyStats['total_items'] ? : 0,
            'total_amount' => $partyStats['total_amount'] ? : 0,
            'paid_items' => $partyStats['paid_items'] ? : 0,
            'paid_amount' => $partyStats['paid_amount'] ? : 0,
            'unpaid_items' => ($partyStats['total_items'] ? : 0) - ($partyStats['paid_items'] ? : 0),
            'unpaid_amount' => ($partyStats['total_amount'] ? : 0) - ($partyStats['paid_amount'] ? : 0),
            'payment_completion_rate' => ($partyStats['total_items'] ? : 0) > 0 ?
                round(($partyStats['paid_items'] ? : 0) / ($partyStats['total_items'] ? : 0) * 100, 1) : 0
        ];

        return view('/admin/party/members', [
            'party' => $party,
            'members' => $members,
            'stats' => $stats
        ]);
    }

    /**
     * 获取派对成员列表（API）
     */
    public function getPartyMembers(Request $request): Json
    {
        $partyId = $request->param('party_id');
        if (! $partyId) {
            return json(['ret' => 0, 'msg' => '参数错误']);
        }

        $members = Db::table('party_member')
            ->join('user', 'party_member.user_id = user.id')
            ->join('party', 'party_member.party_id = party.id')
            ->where('party_member.party_id', $partyId)
            ->field('user.id, user.username, CASE WHEN party.owner_id = party_member.user_id THEN 1 ELSE 0 END as is_owner')
            ->select();

        return json(['ret' => 1, 'data' => $members]);
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
