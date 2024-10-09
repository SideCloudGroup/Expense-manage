<script src="https://unpkg.com/@simplewebauthn/browser/dist/bundle/index.umd.min.js"></script>

<title>{:env('APP.NAME')} - 登录</title>
<body class="border-top-wide border-primary d-flex flex-column">
<div class="page page-center">
    <div class="container-tight my-auto">
        <div class="text-center mb-4">
        </div>
        <div class="card card-md">
            <div class="card-body">
                <h2 class="card-title text-center mb-4">用户登录</h2>
                <div class="mb-2">
                    <label class="form-label">
                        <i class="fa-solid fa-user"></i>
                        用户名
                    </label>
                    <div class="input-group input-group-flat">
                        <input id="username" type="text" class="form-control">
                    </div>
                </div>
                <div class="mb-2">
                    <label class="form-label">
                        <i class="fa-solid fa-lock"></i>
                        密码
                    </label>
                    <div class="input-group input-group-flat">
                        <input id="password" type="password" class="form-control">
                    </div>
                </div>
                <div class="form-footer">
                    <button class="btn btn-primary w-100"
                            hx-post="/auth/login"
                            hx-swap="none"
                            hx-disabled-elt="button"
                            hx-vals='js:{
                                username: document.getElementById("username").value,
                                password: document.getElementById("password").value,
                             }'>
                        登录
                    </button>
                    <button class="btn btn-primary w-100 mt-3" id="webauthnLogin">
                        使用 Passkeys 登录
                    </button>
                </div>
            </div>
        </div>
        {if env("APP.REGISTER_CODE")!=''}
            <div class="text-center text-muted mt-3">
                还没有账户？<a href="/auth/register" tabindex="-1">前往注册</a>
            </div>
        {/if}
    </div>
</div>

{include file="/footer"}

<script>
    let successDialog = new bootstrap.Modal(document.getElementById('success-dialog'));
    let failDialog = new bootstrap.Modal(document.getElementById('fail-dialog'));

    const {startAuthentication} =
    SimpleWebAuthnBrowser;
    document.getElementById('webauthnLogin').addEventListener('click', async () => {
        const resp = await fetch('/auth/webauthn_request');
        let asseResp;
        try {
            asseResp = await startAuthentication(await resp.json());
        } catch (error) {
            document.getElementById("fail-message").innerHTML = error;
            throw error;
        }
        const verificationResp = await fetch('/auth/webauthn_verify', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(asseResp),
        });
        const verificationJSON = await verificationResp.json();
        if (verificationJSON.ret === 1) {
            document.getElementById("success-message").innerHTML = verificationJSON.msg;
            successDialog.show();
            window.location.href = verificationJSON.redir;
        } else {
            document.getElementById("fail-message").innerHTML = verificationJSON.msg;
            failDialog.show();
        }
    });
</script>