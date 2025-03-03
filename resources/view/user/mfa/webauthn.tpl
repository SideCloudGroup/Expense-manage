<div class="col-sm-12 col-md-12 mb-3">
    <div class="card">
        <div class="card-body">
            <h3 class="card-title">Passkey</h3>
            <p class="card-subtitle">Passkey
                是一种新的身份验证标准，使用生物识别或者安全密钥进行身份验证以取代传统密码。</p>
            <div class="row row-cols-1 row-cols-md-4 g-4">
                {foreach $webauthn_devices as $device}
                    <div class="col">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">{$device->name|default='未命名'}</h5>
                                <p class="card-text">添加时间: {$device->created_at}</p>
                                <p class="card-text">上次使用: {$device->used_at|default='从未使用'}</p>
                                <button class="btn btn-danger"
                                        hx-delete="/user/webauthn_reg/{$device->id}"
                                        hx-swap="none"
                                        hx-confirm="确认删除此设备？"
                                >删除
                                </button>
                            </div>
                        </div>
                    </div>
                {/foreach}
            </div>
        </div>
        <div class="card-footer">
            <div class="d-flex">
                <button class="btn btn-primary ms-auto" id="webauthnReg">
                    注册 Passkey 设备
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    const { startRegistration } = SimpleWebAuthnBrowser;
    document.getElementById('webauthnReg').addEventListener('click', async () => {
        const resp = await fetch('/user/webauthn_reg');
        const options = await resp.json();
        let attResp;
        try {
            attResp = await startRegistration({ optionsJSON: options });
        } catch (error) {
            $('#error-message').text(error.message);
            $('#fail-dialog').modal('show');
            throw error;
        }
        attResp.name = prompt("请输入设备名称:");
        const verificationResp = await fetch('/user/webauthn_reg', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(attResp),
        });
        const verificationJSON = await verificationResp.json();
        if (verificationJSON.ret === 1) {
            $('#success-message').text(verificationJSON.msg);
            $('#success-dialog').modal('show');
            setTimeout(function () {
                location.reload();
            }, 1000);
        } else {
            $('#error-message').text(verificationJSON.msg);
            $('#fail-dialog').modal('show');
        }
    });
</script>

