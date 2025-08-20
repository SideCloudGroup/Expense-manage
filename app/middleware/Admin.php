<?php
declare (strict_types=1);

namespace app\middleware;

use Closure;
use think\Request;
use think\Response;

class Admin
{
    /**
     * 处理请求
     *
     * @param Request $request
     * @param Closure $next
     * @return Response
     */
    public function handle($request, Closure $next)
    {
        if ($request->pathinfo() === 'admin/login') {
            return $next($request);
        }

        // 检查用户是否登录
        if (! session('userid')) {
            return redirect('/auth/login');
        }

        // 检查用户是否为管理员
        $user = \app\model\User::find(session('userid'));
        if (! $user || ! $user->is_admin) {
            return redirect('/')->with('error', '无管理员权限');
        }

        return $next($request);
    }
}
