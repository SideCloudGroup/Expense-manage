<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | noded ( http://www.apache.org/nodes/node-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------
use app\middleware\Admin;
use app\middleware\Auth;
use app\middleware\User;
use think\facade\Route;


Route::group('auth', function () {
    Route::get('', 'auth/authPage');
    Route::post('', 'auth/auth');
})->middleware(Auth::class);

Route::rule('/', 'user/invoice')->middleware(User::class);
Route::group('/user', function () {
    Route::get('', 'user/invoice');
    Route::get('/', 'user/invoice');
    Route::get('/unpaid', 'user/unpaid');
    Route::get('/payment', 'user/payment');
    Route::get('/item/add', 'user/addItem');
    Route::post('/item/add', 'user/processAddItem');
    Route::post('/item/:id', 'user/updateItemStatus');
    Route::get('/item', 'user/itemList');
    Route::get('/currency', 'user/currency');
})->middleware(User::class);

Route::group('/admin', function () {
    Route::get('', 'admin/index');
    Route::get('/', 'admin/index');
    Route::get('/user', 'admin/user');
    Route::post('/user', 'admin/addUser');
    Route::post('/item/:id', 'admin/updateItemStatus');
    Route::get('/item', 'admin/itemList');
    Route::get('/total', 'admin/bestPay');
    Route::get('/login', 'admin/loginPage');
    Route::post('/login', 'admin/loginHandler');
})->middleware(Admin::class);