<?php
declare (strict_types=1);

namespace app\middleware;

use Closure;
use think\facade\Session;
use think\Request;
use think\Response;
use function redirect;

class Auth
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
        if (app()->userService->getUser() === null) {
            if (! app()->cookieService->checkCookie()) {
                return $next($request);
            }
        }
        return redirect("/");
    }
}
