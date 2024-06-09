<title>管理面板</title>
<body class="border-top-wide border-primary d-flex flex-column">
<div class="page page-center">
    <div class="container-tight my-auto">
        <div class="text-center mb-4">
        </div>
        <div class="card card-md">
            <div class="card-body">
                <h2 class="card-title text-center mb-4">管理员登录</h2>
                <div class="mb-2">
                    <label class="form-label">
                        密码
                    </label>
                    <div class="input-group input-group-flat">
                        <input id="password" type="password" class="form-control">
                    </div>
                </div>
                <div class="form-footer">
                    <button class="btn btn-primary w-100"
                            hx-post="/admin/login"
                            hx-swap="none"
                            hx-disabled-elt="button"
                            hx-vals='js:{
                                password: document.getElementById("password").value,
                             }'>
                        登录
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
{include file="/footer"}