<?php
declare (strict_types=1);

namespace app\controller;

use app\BaseController;
use app\model\Item;
use app\model\MFACredential;
use app\service\MFA\FIDO;
use app\service\MFA\TOTP;
use app\service\MFA\WebAuthn;
use think\exception\ValidateException;
use think\facade\Cookie;
use think\facade\Db;
use think\facade\Session;
use think\Request;
use think\response\Json;
use think\response\View;
use voku\helper\AntiXSS;

class UserController extends BaseController
{
    public function invoice(Request $request): View
    {
        $user = app()->userService->getUser();
        $items = Db::table('item')
            ->join('user', 'item.initiator = user.id')
            ->where('item.userid', Session::get('userid'))
            ->order(['item.paid', 'item.id'])
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
            app()->userService->addItem((int)$user, $request->param('description'), (float)$amount, session('userid'));
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
        $items = Db::table('item')->join('user', 'item.initiator = user.id')->where('item.userid', Session::get('userid'))->where('item.paid', 0)->order(['item.paid', 'item.id'])->field('item.id,user.username,item.description,item.amount,item.paid,item.created_at')->select();
        return view('/user/payment', ['items' => $items]);
    }

    public function itemList(Request $request): View
    {
        // 当前用户发起的
        $items = Db::table('item')->join('user', 'item.userid = user.id')->order('item.paid')->where('initiator', Session::get('userid'))->order(['item.paid', 'item.id'])->field('item.id,user.username,item.description,item.amount,item.paid,item.created_at')->select();
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

    public function logout(Request $request): Json
    {
        Session::delete('userid');
        Session::delete('auth');
        Cookie::delete('user');
        return json(['ret' => 1, 'msg' => '登出成功'])->header(['HX-Redirect' => '/']);
    }

    public function profile(Request $request): View
    {
        $user = app()->userService->getUser();
        $webauthnDevices = (new MFACredential())->where('userid', $user->id)->where('type', 'passkey')->select();
        $totpDevices = (new MFACredential())->where('userid', $user->id)->where('type', 'totp')->select();
        $fidoDevices = (new MFACredential())->where('userid', $user->id)->where('type', 'fido')->select();
        return view('/user/profile', [
            'user' => $user,
            'webauthn_devices' => $webauthnDevices,
            'totp_devices' => $totpDevices,
            'fido_devices' => $fidoDevices,
        ]);
    }

    public function updateProfile(Request $request): Json
    {
        $user = app()->userService->getUser();
        $user->username = $request->param('username');
        $user->save();
        return json(['ret' => 1, 'msg' => '更新成功'])->header(['HX-Refresh' => 'true']);
    }

    public function webauthnRequestRegister(Request $request): Json
    {
        $user = app()->userService->getUser();
        return json(json_decode(WebAuthn::registerRequest($user)));
    }

    public function webauthnRegisterHandler(Request $request): Json
    {
        $user = app()->userService->getUser();
        $antixss = new AntiXSS();
        return json(WebAuthn::registerHandle($user, $antixss->xss_clean($request->param())));
    }

    public function webauthnDelete(Request $request, string $id): Json
    {
        $user = app()->userService->getUser();
        $device = (new MFACredential())
            ->where('id', (int)$id)
            ->where('userid', $user->id)
            ->where('type', 'passkey')
            ->findOrEmpty();
        if ($device->isEmpty()) {
            return json(['ret' => 0, 'msg' => '设备不存在']);
        }
        $device->delete();
        return json(['ret' => 1, 'msg' => '删除成功'])->header(['HX-Refresh' => 'true']);
    }

    public function totpRegisterRequest(Request $request): Json
    {
        return json(TOTP::totpRegisterRequest(app()->userService->getUser()));
    }

    public function totpRegisterHandle(Request $request): Json
    {
        $antixss = new AntiXSS();
        $code = $antixss->xss_clean($request->param('code'));
        if ($code === '' || $code === null) {
            return json([
                'ret' => 0,
                'msg' => '验证码不能为空',
            ]);
        }

        return json(TOTP::totpRegisterHandle(app()->userService->getUser(), $code));
    }

    public function totpDelete(Request $request): Json
    {
        $user = app()->userService->getUser();
        $device = (new MFACredential())
            ->where('userid', $user->id)
            ->where('type', 'totp')
            ->findOrEmpty();
        if ($device->isEmpty()) {
            return json(['ret' => 0, 'msg' => '设备不存在']);
        }
        $device->delete();
        return json(['ret' => 1, 'msg' => '删除成功'])->header(['HX-Refresh' => 'true']);
    }

    public function fidoRegisterRequest(Request $request): Json
    {
        $user = app()->userService->getUser();
        return json(json_decode(FIDO::fidoRegisterRequest($user)));
    }

    public function fidoRegisterHandle(Request $request): Json
    {
        $user = app()->userService->getUser();
        $antixss = new AntiXSS();
        return json(FIDO::fidoRegisterHandle($user, $antixss->xss_clean($request->param())));
    }

    public function fidoDelete(Request $request, string $id): Json
    {
        $user = app()->userService->getUser();
        $device = (new MFACredential())
            ->where('id', (int)$id)
            ->where('userid', $user->id)
            ->where('type', 'fido')
            ->findOrEmpty();
        if ($device->isEmpty()) {
            return json(['ret' => 0, 'msg' => '设备不存在']);
        }
        $device->delete();
        return json(['ret' => 1, 'msg' => '删除成功'])->header(['HX-Refresh' => 'true']);
    }
}
