<?php
declare (strict_types=1);

namespace app\controller;

use app\BaseController;
use app\model\Item;
use app\model\User;
use think\facade\Db;
use think\Request;
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
        if ($request->param('password') !== env('APP.ADMIN_PASSWORD')) {
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
        $user->save();
        return json(['ret' => 1, 'msg' => '用户已添加'])->header(['HX-Refresh' => 'true']);
    }

    public function itemList(Request $request): View
    {
        $user_id = $request->param('userid');
        if ($user_id === null) {
            $items = Db::table('item')->join('user', 'item.userid = user.id')->order('item.paid')->field('item.id,user.username,item.description,item.amount,item.paid,item.created_at')->select();
        } else {
            $items = Db::table('item')->join('user', 'item.userid = user.id')->order('item.paid')->field('item.id,user.username,item.description,item.amount,item.paid,item.created_at')->where('userid', $user_id)->select();
        }
        return view('/admin/item', ['items' => $items]);
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
        return view('/admin/bestpay', ['users' => $bestPay]);
    }
}
