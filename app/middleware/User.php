<?php
declare (strict_types=1);

namespace app\middleware;

use Closure;
use think\facade\Session;
use think\Request;
use think\Response;
use function redirect;

class User
{
    /**
     * 处理请求
     *
     * @param Request $request
     * @param Closure $next
     * @return Response
     */
    public function handle(Request $request, Closure $next): Response
    {
        if (Session::get("userid") === null) {
            if (! app()->cookieService->checkCookie()) {
                return redirect("/auth");
            }
        }
        return $next($request);
    }
}
