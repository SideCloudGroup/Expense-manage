<?php
declare (strict_types=1);

namespace app\controller;

use app\BaseController;
use app\model\Item;
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
        $user = app()->userService->getUser();
        $items = Db::table('item')
            ->join('user', 'item.initiator = user.id')
            ->where('item.userid', Session::get('userid'))
            ->order('item.paid')
            ->field('item.id,user.username,item.description,item.amount,item.paid,item.created_at')
            ->select();
        $totalPricePaid = 0;
        $totalPriceUnpaid = 0;
        foreach ($items as $item) {
            if ($item['paid'] === 1) {
                $totalPricePaid += $item['amount'];
            } else {
                $totalPriceUnpaid += $item['amount'];
            }
        }
        $totalPrice = $totalPricePaid + $totalPriceUnpaid;
        return view('/user/invoice', ['username' => $user->username, 'items' => $items, 'totalPrice' => $totalPrice, 'totalPricePaid' => $totalPricePaid, 'totalPriceUnpaid' => $totalPriceUnpaid]);
    }

    public function unpaid(Request $request): View
    {
        $result = app()->userService->getBestPay()[0];
        $user = app()->userService->getUser();
        $result = $result[$user->username] ?? [];
        return view('/user/unpaid', ['result' => $result]);
    }

    public function processAddItem(Request $request): Json
    {
        $users = json_decode($request->param('users'));
        try {
            validate(\app\validate\Item::class)->check([
                'description' => $request->param('description'),
                'amount' => $request->param('amount'),
                'users' => $users,
                'unit' => $request->param('unit'),
            ]);
        } catch (ValidateException $e) {
            return json(['ret' => 0, 'msg' => $e->getError()]);
        }
        $baseCurrency = app()->currencyService->getDefaultCurrency();
        $exchangeRate = app()->currencyService->getExchangeRate();
        if ($request->param('unit') === $baseCurrency) {
            $amount = $request->param('amount');
        } else {
            $amount = $request->param('amount') / $exchangeRate[$request->param('unit')];
        }
        foreach ($users as $user) {
            app()->userService->addItem((int) $user, $request->param('description'), (float) $amount, session('userid'));
        }
        return json(['ret' => 1, 'msg' => '添加成功'])->header(['HX-Refresh' => 'true']);
    }

    public function addItem(Request $request): View
    {
        $users = $this->app->userService->getUserList();
        $currencies = $this->app->currencyService->getExchangeRate();
        return view('/user/addItem', ['users' => $users, 'currencies' => $currencies]);
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

    public function currency(Request $request): View
    {
        $baseCurrency = app()->currencyService->getDefaultCurrency();
        $exchangeRate = app()->currencyService->getExchangeRate();
        foreach ($exchangeRate as $currency => $rate) {
            $exchangeRate[$currency] = round(1 / $rate, 3);
        }
        return view('/user/currency', ['baseCurrency' => $baseCurrency, 'currencies' => $exchangeRate]);
    }
}
