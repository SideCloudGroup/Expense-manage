<?php
declare (strict_types=1);

namespace app\controller;

use app\BaseController;
use app\model\Item;
use app\model\User;
use think\exception\ValidateException;
use think\facade\Db;
use think\facade\Session;
use think\Request;
use think\response\Json;
use think\response\View;

class UserController extends BaseController
{
    public function invoice(Request $request): View
    {
        $user = (new User())->where('id', Session::get('userid'))->findOrEmpty();
        if ($user->isEmpty()) {
            Session::delete('userid');
            return view('/auth');
        }
        $items = Db::table('item')->join('user', 'item.initiator = user.id')->where('item.userid', Session::get('userid'))->field('item.id,user.username,item.description,item.amount,item.paid,item.created_at')->select();
        $totalPricePaid = (new Item())->where('userid', Session::get('userid'))->where('paid', 1)->sum('amount');
        $totalPriceUnpaid = (new Item())->where('userid', Session::get('userid'))->where('paid', 0)->sum('amount');
        $totalPrice = $totalPricePaid + $totalPriceUnpaid;
        return view('/user/invoice', ['username' => $user->username, 'items' => $items, 'totalPrice' => $totalPrice, 'totalPricePaid' => $totalPricePaid, 'totalPriceUnpaid' => $totalPriceUnpaid]);
    }

    public function unpaid(Request $request): View
    {
        // 以用户为单位，展示未支付的账单
        $user = (new User())->where('id', Session::get('userid'))->findOrEmpty();
        if ($user->isEmpty()) {
            Session::delete('userid');
            return view('/auth');
        }
        $users = Db::table('user')->field('id, username')->select();
        $result = [];
        foreach ($users as $user) {
            $items = (new Item())->where('userid', Session::get('userid'))->where('paid', 0)->where('initiator', $user['id'])->findOrEmpty();
            if ($items->isEmpty()) {
                continue;
            }
            $totalPrice = (new Item())->where('userid', Session::get('userid'))->where('paid', 0)->where('initiator', $user['id'])->sum('amount');
            $result[] = ['username' => $user['username'], 'items' => $items, 'totalPrice' => $totalPrice];
        }
        return view('/user/unpaid', ['results' => $result]);
    }

    public function addItem(Request $request): View
    {
        $users = (new User())->select();
        return view('/user/addItem', ['users' => $users]);
    }

    public function processAddItem(Request $request): Json
    {
        $users = json_decode($request->param('users'));
        try {
            validate(\app\validate\Item::class)->check([
                'description' => $request->param('description'),
                'amount' => $request->param('amount'),
                'users' => $users
            ]);
        } catch (ValidateException $e) {
            return json(['ret' => 0, 'msg' => $e->getError()]);
        }
        foreach ($users as $user) {
            $item = new Item();
            $item->userid = $user;
            $item->description = $request->param('description');
            $item->amount = $request->param('amount');
            $item->paid = (int) $user === (int) Session::get('userid');
            $item->created_at = date('Y-m-d H:i:s');
            $item->initiator = session('userid');
            $item->save();
        }
        return json(['ret' => 1, 'msg' => '添加成功'])->header(['HX-Refresh' => 'true']);
    }

    public function payment(Request $request): View
    {
        // 当前用户需要支付的
        $items = Db::table('item')->join('user', 'item.initiator = user.id')->where('item.userid', Session::get('userid'))->where('item.paid', 0)->field('item.id,user.username,item.description,item.amount,item.paid,item.created_at')->select();
        return view('/user/payment', ['items' => $items]);
    }

    public function itemList(Request $request): View
    {
        // 当前用户发起的
        $items = Db::table('item')->join('user', 'item.userid = user.id')->order('item.paid')->where('initiator', Session::get('userid'))->field('item.id,user.username,item.description,item.amount,item.paid,item.created_at')->select();
        return view('/user/item', ['items' => $items]);
    }

    public function updateItemStatus(Request $request): Json
    {
        $item = (new Item())->where('id', $request->param('id'))->where('initiator', session('userid'))->findOrEmpty();
        if ($item->isEmpty()) {
            return json(['ret' => 0, 'msg' => '未找到指定项目'])->header(['HX-Refresh' => 'true']);
        }
        $item->paid = $request->param('paid');
        $item->save();
        return json(['ret' => 1, 'msg' => '更新成功'])->header(['HX-Refresh' => 'true']);
    }
}
