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

        if (session('admin') === null && env('APP.ADMIN_PASSWORD') !== "") {
            return redirect('/admin/login');
        }
        return $next($request);
    }
}
