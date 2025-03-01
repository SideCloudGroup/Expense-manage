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

    public function setCookie(User $user): void
    {
        $payload = [
            'exp' => time() + 2592000,
            'nbf' => time(),
            'iat' => time(),
            'uuid' => $user->uuid,
        ];
        $jwt = JWT::encode($payload, hash('sha256', $user->password), 'HS256');
        Cookie::set('user', $jwt, 2592000);
    }

    public function checkCookie(): bool
    {
        try {
            $jwt = Cookie::get('user');
            if (empty($jwt)) {
                return false;
            }
            [, $payload_b64] = explode('.', $jwt);
            $payload = JWT::jsonDecode(JWT::urlsafeB64Decode($payload_b64));
            $user = (new User())->where('uuid', $payload->uuid)->findOrEmpty();
            if ($user->isEmpty()) {
                return false;
            }
            try {
                $decoded = JWT::decode($jwt, new Key(hash('sha256', $user->password), 'HS256'));
            } catch (Exception) {
                return false;
            }
            Session::set('userid', $user->id);
            return true;
        } catch (Exception) {
            Cookie::delete('user');
            return false;
        }
    }
}
