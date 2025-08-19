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
    Route::get('/login', 'auth/loginPage');
    Route::post('/login', 'auth/login');
    Route::get('/register', 'auth/registerPage');
    Route::post('/register', 'auth/register');
    Route::get('/webauthn_request', 'auth/webauthnRequest');
    Route::post('/webauthn_verify', 'auth/webauthnHandler');
    Route::get('/2fa', 'auth/MfaPage');
    Route::post('/totp_verify', 'auth/mfaTotpHandler');
    Route::get('/fido_request', 'auth/mfaFidoRequest');
    Route::post('/fido_verify', 'auth/mfaFidoAssert');
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
    Route::get('/logout', 'user/logout');
    Route::get('/profile', 'user/profile');
    Route::post('/profile', 'user/updateProfile');
    // WebAuthn
    Route::get('/webauthn_reg', 'user/webauthnRequestRegister');
    Route::post('/webauthn_reg', 'user/webauthnRegisterHandler');
    Route::delete('/webauthn_reg/:id', 'user/webauthnDelete');
    //
    // TOTP
    Route::get('/totp_reg', 'user/totpRegisterRequest');
    Route::post('/totp_reg', 'user/totpRegisterHandle');
    Route::delete('/totp_reg', 'user/totpDelete');
    //
    // FIDO
    Route::get('/fido_reg', 'user/fidoRegisterRequest');
    Route::post('/fido_reg', 'user/fidoRegisterHandle');
    Route::delete('/fido_reg/:id', 'user/fidoDelete');
})->middleware(User::class);

Route::group('/admin', function () {
    Route::get('', 'admin/index');
    Route::get('/', 'admin/index');
    Route::get('/user', 'admin/user');
    Route::post('/user', 'admin/addUser');
    Route::post('/item/:id', 'admin/updateItemStatus');
    Route::delete('/item/:id', 'admin/itemDelete');
    Route::get('/item', 'admin/itemList');
    Route::get('/total/download', 'admin/downloadBestPay');
    Route::post('/total/clear', 'admin/clearBestPay');
    Route::get('/total', 'admin/bestPay');
    Route::get('/login', 'admin/loginPage');
    Route::post('/login', 'admin/loginHandler');
})->middleware(Admin::class);