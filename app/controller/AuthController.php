<?php
declare (strict_types=1);

namespace app\controller;

use app\BaseController;
use app\model\User;
use app\validate\UserLogin;
use app\validate\UserRegister;
use think\exception\ValidateException;
use think\facade\Session;
use think\Request;
use think\response\Json;
use think\response\Redirect;
use think\response\View;
use voku\helper\AntiXSS;

class AuthController extends BaseController
{
    public function login(Request $request): Json
    {
        if (Session::get('auth') === true) {
            return json(['ret' => 0, 'msg' => '已经登录'])->header(['HX-Redirect' => '/']);
        }
        $antixss = new AntiXSS();
        $data = [
            'username' => $antixss->xss_clean($request->param('username')),
            'password' => $antixss->xss_clean($request->param('password')),
        ];
        try {
            validate(UserLogin::class)->check($data);
        } catch (ValidateException $e) {
            return json(['ret' => 0, 'msg' => $e->getError()]);
        }
        $user = (new User())->where('username', $data['username'])->findOrEmpty();
        if ($user->isEmpty()) {
            return json(['ret' => 0, 'msg' => '用户不存在']);
        } else {
            if (password_verify($data['password'], $user->password)) {
                Session::set('userid', $user->id);
                app()->cookieService->setCookie($user->id);
                return json(['ret' => 1, 'msg' => '登录成功'])->header(['HX-Redirect' => '/']);
            } else {
                return json(['ret' => 0, 'msg' => '密码错误']);
            }
        }
    }

    public function loginPage(): View|Redirect
    {
        if (Session::get('userid') !== null && Session::get('auth') === true) {
            return redirect('/');
        }
        return view('/auth/login');
    }

    public function registerPage(): View|Redirect
    {
        if (env('APP.REGISTER_CODE') == '') {
            return redirect('/auth/login');
        }
        return view('/auth/register');
    }

    public function register(Request $request): Json
    {
        if (env('APP.REGISTER_CODE') == '') {
            return json(['ret' => 0, 'msg' => '注册已关闭']);
        }
        $antixss = new AntiXSS();
        $data = [
            'username' => $antixss->xss_clean($request->param('username')),
            'password' => $antixss->xss_clean($request->param('password')),
            'confirm_password' => $antixss->xss_clean($request->param('confirm_password')),
            'register_code' => $antixss->xss_clean($request->param('register_code')),
            'captcha' => $antixss->xss_clean($request->param('captcha')),
        ];
        # 验证码
        if (!captcha_check($data['captcha'])) {
            return json(['ret' => 0, 'msg' => '验证码错误']);
        }
        # 密码
        if ($data['password'] !== $data['confirm_password']) {
            return json(['ret' => 0, 'msg' => '两次密码不一致']);
        }
        try {
            validate(UserRegister::class)->check($data);
        } catch (ValidateException $e) {
            return json(['ret' => 0, 'msg' => $e->getError()]);
        }
        if ($data['register_code'] !== env('APP.REGISTER_CODE')) {
            return json(['ret' => 0, 'msg' => '注册码错误']);
        }
        $user = (new User())->where('username', $data['username'])->findOrEmpty();
        if (!$user->isEmpty()) {
            return json(['ret' => 0, 'msg' => '用户已存在']);
        }
        $user = new User();
        $user->username = $data['username'];
        $user->password = password_hash($data['password'], PASSWORD_ARGON2ID);
        $user->save();
        return json(['ret' => 1, 'msg' => '注册成功'])->header(['HX-Redirect' => '/auth/login']);
    }
}
