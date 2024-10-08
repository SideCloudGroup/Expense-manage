{include file='/user/header'}

<title>个人信息</title>

<div class="page">
    <div class="page-wrapper">
        <div class="container mt-5">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">修改个人信息</h3>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-sm-12 col-lg-6">
                            <div class="input-group mb-3">
                                <span class="input-group-text">用户名</span>
                                <input class="form-control" id="username" type="text"
                                       value="{$user.username}">
                            </div>
                        </div>
                        <div class="col-sm-12 col-lg-6">
                            <div class="input-group mb-3">
                                <span class="input-group-text">密码</span>
                                <input class="form-control" id="password" type="text"
                                       placeholder="不修改请留空">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <button class="btn btn-primary"
                            hx-post="/user/profile"
                            hx-include="[id='username'], [id='password']"
                            hx-target="body">更新
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>