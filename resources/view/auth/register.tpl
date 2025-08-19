<title>{:getSetting('general_name')} - 注册</title>

<body class=" d-flex flex-column">
<div class="page page-center">
    <div class="container container-tight py-4">
        <div class="card card-md">
            <div class="card-body">
                <form hx-post="/auth/register" hx-swap="none" hx-trigger="submit">
                <h2 class="h2 text-center mb-4">用户注册</h2>
                <div class="mb-3">
                    <label class="form-label"><i class="fa-solid fa-user"></i> 用户名</label>
                    <input class="form-control" name="username" placeholder="请输入用户名"
                           type="text">
                </div>
                <div class="mb-2">
                    <label class="form-label"><i class="fa-solid fa-lock"></i> 密码</label>
                    <div class="input-group input-group-flat">
                        <input class="form-control" name="password" placeholder="请输入密码"
                               required type="password">
                    </div>
                </div>
                <div class="mb-2">
                    <label class="form-label">
                        重复密码
                    </label>
                    <div class="input-group input-group-flat">
                        <input class="form-control" name="confirm_password"
                               placeholder="请重复密码" required type="password">
                    </div>
                </div>
                <div class="mb-2">
                        {include file="/captcha"}
                    </div>
                <div class="form-footer">
                    <button class="btn btn-primary w-100" type="submit">
                        注册
                    </button>
                </div>
                </form>
            </div>
        </div>
        <div class="text-center text-muted mt-3">
            已有账号？<a href="/auth/login" tabindex="-1">前往登录</a>
        </div>
    </div>
</div>
</body>

{include file="/footer"}

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
</script>