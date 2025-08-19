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

    public function loginPage(Request $request): View
    {
        return view('/admin/login');
    }

    public function loginHandler(Request $request): Json
    {
        if ($request->param('password') !== env('ADMIN_PASSWORD')) {
            return json(['ret' => 0, 'msg' => '管理员密码错误']);
        }
        session('admin', true);
        return json(['ret' => 1, 'msg' => '登录成功'])->header(['HX-Redirect' => '/admin']);
    }

    public function user(Request $request): View
    {
        $users = (new User())->field('id,username')->select();
        return view('/admin/user', ['users' => $users]);
    }

    public function addUser(Request $request): Json
    {
        $user = new User();
        $user->username = $request->param('username');
        $user->password = password_hash($request->param('password'), PASSWORD_ARGON2ID);
        $user->uuid = Uuid::uuid4()->toString();
        $user->save();
        return json(['ret' => 1, 'msg' => '用户已添加'])->header(['HX-Refresh' => 'true']);
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
}
