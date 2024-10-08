<title>注册喵</title>
<body class=" d-flex flex-column">
<div class="page page-center">
    <div class="container container-tight py-4">
        <div class="card card-md">
            <div class="card-body">
                <h2 class="h2 text-center mb-4">用户注册</h2>
                <div class="mb-3">
                    <label class="form-label"><i class="fa-solid fa-user"></i> 用户名</label>
                    <input class="form-control" id="username" placeholder="请输入用户名"
                           type="text">
                </div>
                <div class="mb-2">
                    <label class="form-label"><i class="fa-solid fa-lock"></i> 密码</label>
                    <div class="input-group input-group-flat">
                        <input class="form-control" id="password" placeholder="请输入密码"
                               required type="password">
                    </div>
                </div>
                <div class="mb-2">
                    <label class="form-label">
                        重复密码
                    </label>
                    <div class="input-group input-group-flat">
                        <input class="form-control" id="confirm_password"
                               placeholder="请重复密码" required type="password">
                    </div>
                </div>
                <div class="mb-2">
                    <label class="form-label"><i class="fa-solid fa-certificate"></i> 注册码</label>
                    <div class="input-group input-group-flat">
                        <input class="form-control" id="register_code" placeholder="请输入注册码" required type="text">
                    </div>
                </div>
                <div class="mb-2">
                    <label class="form-label"><i class="fas fa-key"></i> 验证码</label>
                    <div class="row">
                        <div class="col">
                            <div class="input-group input-group-flat">
                                <input class="form-control" id="captcha"
                                       placeholder="请输入验证码"
                                       type="text">
                            </div>
                        </div>
                        <div class="col">
                            <img alt="captcha" onClick="refreshCaptcha();"
                                 src="{:captcha_src()}"/>
                        </div>
                    </div>
                </div>
                <div class="form-footer">
                    <button class="btn btn-primary w-100"
                            hx-post="/auth/register"
                            hx-swap="none"
                            hx-disabled-elt="button"
                            hx-vals='js:{
                                username: document.getElementById("username").value,
                                password: document.getElementById("password").value,
                                confirm_password: document.getElementById("confirm_password").value,
                                register_code: document.getElementById("register_code").value,
                                captcha: document.getElementById("captcha").value,
                             }'
                    >
                        注册
                    </button>
                </div>
            </div>
        </div>
        <div class="text-center text-muted mt-3">
            已有账号？<a href="/auth/login" tabindex="-1">前往登录</a>
        </div>
    </div>
</div>
</body>
<script>
    var passwordInput = $('input[id="password"]');
    var confirmPasswordInput = $('input[id="confirm_password"]');
    passwordInput.on('input', checkPasswordMatch);
    confirmPasswordInput.on('input', checkPasswordMatch);

    function checkPasswordMatch() {
        var password = passwordInput.val();
        var confirmPassword = confirmPasswordInput.val();

        if (password === confirmPassword && confirmPassword !== '') {
            confirmPasswordInput.removeClass('is-invalid').addClass('is-valid');
        } else {
            confirmPasswordInput.removeClass('is-valid').addClass('is-invalid');
        }
    }

    htmx.on("htmx:afterRequest", function (evt) {
        let res = JSON.parse(evt.detail.xhr.response);
        if (res.ret === 0) {
            refreshCaptcha();
        }
    });

    function refreshCaptcha() {
        $('img[alt="captcha"]').attr('src', '{:captcha_src()}?' + Math.random());
    }
</script>
{include file="/footer"}