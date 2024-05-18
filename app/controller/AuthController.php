<?php
declare (strict_types=1);

namespace app\controller;

use app\BaseController;
use app\model\User;
use think\facade\Session;
use think\Request;
use think\response\Json;
use think\response\View;

class AuthController extends BaseController
{
    public function auth(Request $request): Json
    {
        if (Session::get('auth') === true) {
            return json(['ret' => 0, 'msg' => '已经登录'])->header(['HX-Redirect' => '/']);
        }
        $user = (new User())->where('username', $request->param('username'))->findOrEmpty();
        if ($user->isEmpty()) {
            return json(['ret' => 0, 'msg' => '用户不存在']);
        } else {
            if (password_verify($request->param('password'), $user->password)) {
                Session::set('userid', $user->id);
                app()->cookieService->setCookie($user->id);
                return json(['ret' => 1, 'msg' => '登录成功'])->header(['HX-Redirect' => '/']);
            } else {
                return json(['ret' => 0, 'msg' => '密码错误']);
            }
        }
    }

    public function authPage(): View
    {
        return view('/auth/login');
    }
}
