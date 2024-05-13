<?php
declare (strict_types=1);

namespace app\service;

use app\model\User;
use Exception;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use think\facade\Cookie;
use think\facade\Session;
use think\Service;

class CookieService extends Service
{
    public function register()
    {
        $this->app->bind('cookieService', CookieService::class);
    }

    public function setCookie(int $userID): void
    {
        $payload = [
            'exp' => time() + 2592000,
            'nbf' => time(),
            'iat' => time(),
            'userid' => $userID
        ];
        $jwt = JWT::encode($payload, env('APP.COOKIE_KEY'), 'HS256');
        Cookie::set('user', $jwt, 2592000);
    }

    public function checkCookie(): bool
    {
        $jwt = Cookie::get('user');
        if (empty($jwt)) {
            return false;
        }
        try {
            $decoded = JWT::decode($jwt, new Key(env('APP.COOKIE_KEY'), 'HS256'));
            if ($decoded->exp < time()) {
                return false;
            }
            $user = (new User())->where('id', $decoded->userid)->findOrEmpty();
            if ($user->isEmpty()) {
                return false;
            }
            Session::set('userid', $decoded->userid);
            return true;
        } catch (Exception) {
            return false;
        }
    }
}
