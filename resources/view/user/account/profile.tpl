{include file='/user/header'}

<title>{:env('APP_NAME')} - 个人信息</title>

<script src="https://unpkg.com/@simplewebauthn/browser/dist/bundle/index.umd.min.js"></script>

<div class="page">
    <div class="page-wrapper">
        <div class="container mt-5">
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile"
                            type="button" role="tab" aria-controls="profile" aria-selected="true">修改个人信息
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="webauthn-tab" data-bs-toggle="tab" data-bs-target="#webauthn"
                            type="button" role="tab" aria-controls="webauthn" aria-selected="false">WebAuthn
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="totp-tab" data-bs-toggle="tab" data-bs-target="#totp" type="button"
                            role="tab" aria-controls="totp" aria-selected="false">二步验证
                    </button>
                </li>
            </ul>
            <div class="tab-content" id="myTabContent">
                <div class="tab-pane fade show active" id="profile" role="tabpanel" aria-labelledby="profile-tab">
                    <div class="card mt-3">
                        <div class="card-header">
                            <h3 class="card-title">修改个人信息</h3>
                        </div>
                        <div class="card-body">
                            <div class="input-group mb-3">
                                <span class="input-group-text">用户名</span>
                                <input class="form-control" id="username" type="text" value="{$user.username}">
                            </div>
                            <div class="input-group mb-3">
                                <span class="input-group-text">密码</span>
                                <input class="form-control" id="password" type="text" placeholder="不修改请留空">
                            </div>
                        </div>
                        <div class="card-footer">
                            <button class="btn btn-primary"
                                    hx-post="/user/profile"
                                    hx-vals='js:{
                                username: document.getElementById("username").value,
                                password: document.getElementById("password").value,
                             }'>更新
                            </button>
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade" id="webauthn" role="tabpanel" aria-labelledby="webauthn-tab">
                    <div class="card mt-3">
                        <div class="card-header">
                            <h3 class="card-title">WebAuthn</h3>
                        </div>
                        <div class="card-body">
                            {include file="/user/mfa/webauthn"}
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade" id="totp" role="tabpanel" aria-labelledby="totp-tab">
                    <div class="card mt-3">
                        <div class="card-header">
                            <h3 class="card-title">二步验证</h3>
                        </div>
                        <div class="card-body">
                            {include file="/user/mfa/totp"}
                            {include file="/user/mfa/fido"}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="/footer"}